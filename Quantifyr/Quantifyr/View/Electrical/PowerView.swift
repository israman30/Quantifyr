//
//  PowerView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum PowerFormula: String, CaseIterable {
    case pVI = "P = V × I"
    case pI2R = "P = I²R"
    case pV2R = "P = V² / R"
    case energy = "E = P × t"
}

struct PowerView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var formula: PowerFormula = .pVI
    @State private var voltage = ""
    @State private var current = ""
    @State private var resistance = ""
    @State private var powerInput = ""
    @State private var time = ""
    @State private var hasCalculated = false
    
    private var power: Double? {
        switch formula {
        case .pVI:
            guard let v = Double(voltage),
                  let i = Double(current) else { return nil }
            return v * i
        case .pI2R:
            guard let i = Double(current),
                  let r = Double(resistance) else { return nil }
            return i * i * r
        case .pV2R:
            guard let v = Double(voltage),
                  let r = Double(resistance), r != 0 else { return nil }
            return (v * v) / r
        case .energy:
            guard let p = Double(powerInput),
                  let t = Double(time), p >= 0, t >= 0 else { return nil }
            return p * t
        }
    }
    
    private var steps: [String] {
        guard power != nil else { return [] }
        switch formula {
        case .pVI:
            guard let v = Double(voltage),
                  let i = Double(current) else { return [] }
            return [
                "Given: V = \(v) V, I = \(i) A",
                "P = V × I",
                "P = \(v) × \(i)"
            ]
        case .pI2R:
            guard let i = Double(current),
                  let r = Double(resistance) else { return [] }
            return [
                "Given: I = \(i) A, R = \(r) Ω",
                "P = I² × R",
                "P = \(i)² × \(r)"
            ]
        case .pV2R:
            guard let v = Double(voltage),
                  let r = Double(resistance) else { return [] }
            return [
                "Given: V = \(v) V, R = \(r) Ω",
                "P = V² / R",
                "P = \(v)² / \(r)"
            ]
        case .energy:
            guard let p = Double(powerInput),
                  let t = Double(time) else { return [] }
            return [
                "Given: P = \(p) W, t = \(t) s",
                "E = P × t",
                "E = \(p) × \(t)"
            ]
        }
    }
    
    private var formulaVariables: [FormulaVariable] {
        if formula == .energy {
            return [
                FormulaVariable(id: "e", symbol: "E", name: "Energy", unit: "Joules (J)", color: AppTheme.Category.electrical, icon: "bolt.circle"),
                FormulaVariable(id: "p", symbol: "P", name: "Power", unit: "Watts (W)", color: .blue, icon: "gauge.with.dots.needle.67percent"),
                FormulaVariable(id: "t", symbol: "t", name: "Time", unit: "Seconds (s)", color: .green, icon: "clock")
            ]
        }
        return [
            FormulaVariable(id: "p", symbol: "P", name: "Power", unit: "Watts (W)", color: AppTheme.Category.electrical, icon: "gauge.with.dots.needle.67percent"),
            FormulaVariable(id: "v", symbol: "V", name: "Voltage", unit: "Volts (V)", color: .blue, icon: "bolt.fill"),
            FormulaVariable(id: "i", symbol: "I", name: "Current", unit: "Amps (A)", color: .green, icon: "arrow.right"),
            FormulaVariable(id: "r", symbol: "R", name: "Resistance", unit: "Ohms (Ω)", color: .orange, icon: "rectangle.3.group")
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaVisualizerView(
                    formula: formula.rawValue,
                    variables: formulaVariables,
                    title: formula == .energy ? "Energy" : "Power Law"
                )
                
                Form {
                    Section("Formula") {
                        Picker("Use", selection: $formula) {
                            ForEach(PowerFormula.allCases, id: \.self) { f in
                                Text(f.rawValue).tag(f)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Input Values") {
                        if formula == .energy {
                            TextField("Power (W)", text: $powerInput)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($powerInput)
                            TextField("Time (s)", text: $time)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($time)
                        } else {
                            if formula != .pI2R {
                                TextField("Voltage (V)", text: $voltage)
                                    .keyboardType(.decimalPad)
                                    .validatedDecimalInput($voltage)
                            }
                            if formula != .pV2R {
                                TextField("Current (A)", text: $current)
                                    .keyboardType(.decimalPad)
                                    .validatedDecimalInput($current)
                            }
                            if formula != .pVI {
                                TextField("Resistance (Ω)", text: $resistance)
                                    .keyboardType(.decimalPad)
                                    .validatedDecimalInput($resistance)
                            }
                        }
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let p = power {
                                let (unit, name) = formula == .energy ? ("J", "Energy") : ("W", "Power")
                                historyManager.add(formulaName: name, result: String(format: "%.4g \(unit)", p))
                            }
                        } label: {
                            Text("Calculate")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(power == nil)
                    }
                    
                    if hasCalculated, let power {
                        Section("Result") {
                            let resultStr = formula == .energy
                                ? String(format: "%.4g J", power)
                                : String(format: "%.4g W", power)
                            ResultWithActionsView(result: resultStr, fullText: (steps + [resultStr]).joined(separator: "\n"))
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: formula == .energy ? String(format: "%.4g J", power) : String(format: "%.4g W", power)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Power")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("power")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("power") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("power") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PowerView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
