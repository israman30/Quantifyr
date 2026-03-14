//
//  OhmsLawView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum OhmsLawSolveFor: String, CaseIterable {
    case voltage = "Voltage (V)"
    case current = "Current (I)"
    case resistance = "Resistance (R)"
}

// Color coding for students: Voltage → Blue, Current → Green, Resistance → Orange
private enum OhmsLawColor {
    static let voltage = Color.blue
    static let current = Color.green
    static let resistance = Color.orange
}

struct OhmsLawView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var solveFor: OhmsLawSolveFor = .current
    @State private var voltage = ""
    @State private var current = ""
    @State private var resistance = ""
    @State private var hasCalculated = false
    
    private var result: (value: Double, unit: String)? {
        switch solveFor {
        case .voltage:
            guard let i = Double(current), let r = Double(resistance), r != 0 else { return nil }
            return (i * r, "V")
        case .current:
            guard let v = Double(voltage), let r = Double(resistance), r != 0 else { return nil }
            return (v / r, "A")
        case .resistance:
            guard let v = Double(voltage), let i = Double(current), i != 0 else { return nil }
            return (v / i, "Ω")
        }
    }
    
    private var resultString: String? {
        guard let r = result else { return nil }
        let unitName = r.unit == "A" ? "Amps" : (r.unit == "V" ? "Volts" : "Ohms")
        return "\(solveFor == .current ? "I" : (solveFor == .voltage ? "V" : "R")) = \(String(format: "%.4g", r.value)) \(unitName)"
    }
    
    private var steps: [String] {
        guard result != nil else { return [] }
        switch solveFor {
        case .voltage:
            guard let i = Double(current), let res = Double(resistance) else { return [] }
            return [
                "Given: I = \(i) A, R = \(res) Ω",
                "V = I × R",
                "V = \(i) × \(res)"
            ]
        case .current:
            guard let v = Double(voltage), let res = Double(resistance) else { return [] }
            return [
                "Given: V = \(v) V, R = \(res) Ω",
                "I = V / R",
                "I = \(v) / \(res)"
            ]
        case .resistance:
            guard let v = Double(voltage), let i = Double(current) else { return [] }
            return [
                "Given: V = \(v) V, I = \(i) A",
                "R = V / I",
                "R = \(v) / \(i)"
            ]
        }
    }
    
    private var canCalculate: Bool {
        switch solveFor {
        case .voltage: return Double(current) != nil && Double(resistance) != nil && (Double(resistance) ?? 0) != 0
        case .current: return Double(voltage) != nil && Double(resistance) != nil && (Double(resistance) ?? 0) != 0
        case .resistance: return Double(voltage) != nil && Double(current) != nil && (Double(current) ?? 0) != 0
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Visual Formula Section - large typography
                VStack(spacing: 12) {
                    Text("Ohm's Law")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("V = I × R")
                        .font(.system(size: 36, weight: .bold))
                        .fontDesign(.monospaced)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                    HStack(spacing: 12) {
                        Label("V = Voltage", systemImage: "bolt.fill")
                            .font(.caption)
                            .foregroundStyle(OhmsLawColor.voltage)
                        Label("I = Current", systemImage: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(OhmsLawColor.current)
                        Label("R = Resistance", systemImage: "rectangle.3.group")
                            .font(.caption)
                            .foregroundStyle(OhmsLawColor.resistance)
                    }
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                
                Form {
                    Section {
                        Picker("Calculate", selection: $solveFor) {
                            ForEach(OhmsLawSolveFor.allCases, id: \.self) { opt in
                                Text(opt.rawValue).tag(opt)
                            }
                        }
                        .pickerStyle(.menu)
                    } header: {
                        Text("Calculate")
                    }
                    
                    Section("Input Values") {
                        if solveFor != .voltage {
                            TextField("Voltage (V)", text: $voltage)
                                .keyboardType(.decimalPad)
                                .foregroundStyle(OhmsLawColor.voltage)
                                .validatedDecimalInput($voltage)
                        }
                        if solveFor != .current {
                            TextField("Current (A)", text: $current)
                                .keyboardType(.decimalPad)
                                .foregroundStyle(OhmsLawColor.current)
                                .validatedDecimalInput($current)
                        }
                        if solveFor != .resistance {
                            TextField("Resistance (Ω)", text: $resistance)
                                .keyboardType(.decimalPad)
                                .foregroundStyle(OhmsLawColor.resistance)
                                .validatedDecimalInput($resistance)
                        }
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Ohm's Law", result: str)
                            }
                        } label: {
                            Text("Calculate")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canCalculate)
                    }
                    
                    if hasCalculated, let resultString {
                        Section("Result") {
                            ResultWithActionsView(result: resultString, fullText: ([resultString] + steps).joined(separator: "\n"))
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: resultString
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Ohm's Law")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("ohms_law")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("ohms_law") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("ohms_law") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OhmsLawView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
