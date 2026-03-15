//
//  UnitConverterView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum ConversionCategory: String, CaseIterable {
    case length = "Length"
    case weight = "Weight"
    case temperature = "Temperature"
    case speed = "Speed"
    case energy = "Energy"
}

struct UnitConverterView: View {
    @Environment(HistoryManager.self) private var historyManager
    @State private var selectedCategory: ConversionCategory = .length
    @State private var inputValue = ""
    @State private var fromUnitIndex = 0
    @State private var toUnitIndex = 1
    
    private var result: String {
        guard let value = Double(inputValue) else { return "—" }
        let converted = convert(value: value, from: fromUnitIndex, to: toUnitIndex)
        return String(format: "%.6g", converted)
    }
    
    private var canSaveToHistory: Bool {
        guard let _ = Double(inputValue) else { return false }
        return true
    }
    
    private var fromUnits: [String] {
        switch selectedCategory {
        case .length: return ["m", "ft", "km", "mi"]
        case .weight: return ["kg", "lb", "g", "oz"]
        case .temperature: return ["°C", "°F", "K"]
        case .speed: return ["km/h", "mph"]
        case .energy: return ["J", "cal"]
        }
    }
    
    private var toUnits: [String] { fromUnits }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ConversionCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Convert") {
                    TextField("Value", text: $inputValue)
                        .keyboardType(.decimalPad)
                        .validatedDecimalInput($inputValue)
                    
                    HStack {
                        Picker("From", selection: $fromUnitIndex) {
                            ForEach(Array(fromUnits.enumerated()), id: \.offset) { i, u in
                                Text(u).tag(i)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                        
                        Picker("To", selection: $toUnitIndex) {
                            ForEach(Array(toUnits.enumerated()), id: \.offset) { i, u in
                                Text(u).tag(i)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Result") {
                    let resultText = "\(result) \(toUnits[toUnitIndex])"
                    ResultWithActionsView(result: resultText)
                    
                    Button {
                        historyManager.add(formulaName: selectedCategory.rawValue, result: "\(result) \(toUnits[toUnitIndex])")
                    } label: {
                        Label("Save to History", systemImage: "clock.arrow.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .disabled(!canSaveToHistory)
                }
            }
            .numericKeyboardToolbar()
            .navigationTitle("Unit Converter")
        }
    }
    
    private func convert(value: Double, from: Int, to: Int) -> Double {
        if from == to { return value }
        
        switch selectedCategory {
        case .length:
            let meters = toMeters(value, from: from)
            return fromMeters(meters, to: to)
        case .weight:
            let kg = toKg(value, from: from)
            return fromKg(kg, to: to)
        case .temperature:
            let celsius = toCelsius(value, from: from)
            return fromCelsius(celsius, to: to)
        case .speed:
            let kmh = toKmh(value, from: from)
            return fromKmh(kmh, to: to)
        case .energy:
            let joules = toJoules(value, from: from)
            return fromJoules(joules, to: to)
        }
    }
    
    // Length: m, ft, km, mi
    private func toMeters(_ v: Double, from: Int) -> Double {
        switch from {
        case 0: return v
        case 1: return v * 0.3048
        case 2: return v * 1000
        case 3: return v * 1609.34
        default: return v
        }
    }
    private func fromMeters(_ v: Double, to: Int) -> Double {
        switch to {
        case 0: return v
        case 1: return v / 0.3048
        case 2: return v / 1000
        case 3: return v / 1609.34
        default: return v
        }
    }
    
    // Weight: kg, lb, g, oz
    private func toKg(_ v: Double, from: Int) -> Double {
        switch from {
        case 0: return v
        case 1: return v * 0.453592
        case 2: return v / 1000
        case 3: return v * 0.0283495
        default: return v
        }
    }
    private func fromKg(_ v: Double, to: Int) -> Double {
        switch to {
        case 0: return v
        case 1: return v / 0.453592
        case 2: return v * 1000
        case 3: return v / 0.0283495
        default: return v
        }
    }
    
    // Temperature: °C, °F, K
    private func toCelsius(_ v: Double, from: Int) -> Double {
        switch from {
        case 0: return v
        case 1: return (v - 32) * 5/9
        case 2: return v - 273.15
        default: return v
        }
    }
    private func fromCelsius(_ v: Double, to: Int) -> Double {
        switch to {
        case 0: return v
        case 1: return v * 9/5 + 32
        case 2: return v + 273.15
        default: return v
        }
    }
    
    // Speed: km/h, mph
    private func toKmh(_ v: Double, from: Int) -> Double {
        from == 0 ? v : v * 1.60934
    }
    private func fromKmh(_ v: Double, to: Int) -> Double {
        to == 0 ? v : v / 1.60934
    }
    
    // Energy: J, cal
    private func toJoules(_ v: Double, from: Int) -> Double {
        from == 0 ? v : v * 4.184
    }
    private func fromJoules(_ v: Double, to: Int) -> Double {
        to == 0 ? v : v / 4.184
    }
}

#Preview {
    UnitConverterView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
}
