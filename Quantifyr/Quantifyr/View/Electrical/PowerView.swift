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
}

struct PowerView: View {
    @State private var formula: PowerFormula = .pVI
    @State private var voltage = ""
    @State private var current = ""
    @State private var resistance = ""
    
    private var power: Double? {
        switch formula {
        case .pVI:
            guard let v = Double(voltage), let i = Double(current) else { return nil }
            return v * i
        case .pI2R:
            guard let i = Double(current), let r = Double(resistance) else { return nil }
            return i * i * r
        case .pV2R:
            guard let v = Double(voltage), let r = Double(resistance), r != 0 else { return nil }
            return (v * v) / r
        }
    }
    
    private var steps: [String] {
        guard let p = power else { return [] }
        switch formula {
        case .pVI:
            guard let v = Double(voltage), let i = Double(current) else { return [] }
            return [
                "Given: V = \(v) V, I = \(i) A",
                "P = V × I",
                "P = \(v) × \(i)"
            ]
        case .pI2R:
            guard let i = Double(current), let r = Double(resistance) else { return [] }
            return [
                "Given: I = \(i) A, R = \(r) Ω",
                "P = I² × R",
                "P = \(i)² × \(r)"
            ]
        case .pV2R:
            guard let v = Double(voltage), let r = Double(resistance) else { return [] }
            return [
                "Given: V = \(v) V, R = \(r) Ω",
                "P = V² / R",
                "P = \(v)² / \(r)"
            ]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: formula.rawValue,
                    variables: ["P = Power (W)", "V = Voltage (V)", "I = Current (A)", "R = Resistance (Ω)"]
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
                        if formula != .pI2R {
                            TextField("Voltage (V)", text: $voltage)
                                .keyboardType(.decimalPad)
                        }
                        if formula != .pV2R {
                            TextField("Current (A)", text: $current)
                                .keyboardType(.decimalPad)
                        }
                        if formula != .pVI {
                            TextField("Resistance (Ω)", text: $resistance)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    if let power {
                        Section("Result") {
                            Text(String(format: "%.4g W", power))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "%.4g W", power)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Power")
    }
}

#Preview {
    NavigationStack {
        PowerView()
    }
}
