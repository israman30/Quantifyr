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

struct OhmsLawView: View {
    @State private var solveFor: OhmsLawSolveFor = .current
    @State private var voltage = ""
    @State private var current = ""
    @State private var resistance = ""
    
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
    
    private var steps: [String] {
        guard let r = result else { return [] }
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "V = I × R",
                    variables: ["V = Voltage (V)", "I = Current (A)", "R = Resistance (Ω)"]
                )
                
                Form {
                    Section("Solve for") {
                        Picker("Calculate", selection: $solveFor) {
                            ForEach(OhmsLawSolveFor.allCases, id: \.self) { opt in
                                Text(opt.rawValue).tag(opt)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Input Values") {
                        if solveFor != .voltage {
                            TextField("Voltage (V)", text: $voltage)
                                .keyboardType(.decimalPad)
                        }
                        if solveFor != .current {
                            TextField("Current (A)", text: $current)
                                .keyboardType(.decimalPad)
                        }
                        if solveFor != .resistance {
                            TextField("Resistance (Ω)", text: $resistance)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    if let result {
                        Section("Result") {
                            Text(String(format: "%.4g \(result.unit)", result.value))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "%.4g \(result.unit)", result.value)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Ohm's Law")
    }
}

#Preview {
    NavigationStack {
        OhmsLawView()
    }
}
