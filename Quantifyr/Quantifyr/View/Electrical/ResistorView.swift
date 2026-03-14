//
//  ResistorView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum ResistorConfig: String, CaseIterable {
    case series = "Series"
    case parallel = "Parallel"
}

struct ResistorView: View {
    @State private var config: ResistorConfig = .series
    @State private var r1 = ""
    @State private var r2 = ""
    @State private var r3 = ""
    
    private var totalResistance: Double? {
        let values = [r1, r2, r3].compactMap { Double($0) }.filter { $0 > 0 }
        guard !values.isEmpty else { return nil }
        
        switch config {
        case .series:
            return values.reduce(0, +)
        case .parallel:
            let invSum = values.map { 1 / $0 }.reduce(0, +)
            return invSum > 0 ? 1 / invSum : nil
        }
    }
    
    private var formula: String {
        config == .series ? "R_total = R₁ + R₂ + R₃ + ..." : "1/R_total = 1/R₁ + 1/R₂ + 1/R₃ + ..."
    }
    
    private var steps: [String] {
        guard totalResistance != nil else { return [] }
        let values = [r1, r2, r3].compactMap { Double($0) }.filter { $0 > 0 }
        switch config {
        case .series:
            let sum = values.map { String($0) }.joined(separator: " + ")
            return [
                "Given: R₁ = \(values[0])Ω" + (values.count > 1 ? ", R₂ = \(values[1])Ω" : "") + (values.count > 2 ? ", R₃ = \(values[2])Ω" : ""),
                "R_total = R₁ + R₂ + ...",
                "R_total = \(sum)"
            ]
        case .parallel:
            return [
                "Given resistors in parallel",
                "1/R_total = 1/R₁ + 1/R₂ + ...",
                "R_total = 1 / (sum of reciprocals)"
            ]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: formula,
                    variables: ["R_total = Total resistance (Ω)"]
                )
                
                Form {
                    Section("Configuration") {
                        Picker("Type", selection: $config) {
                            Text("Series").tag(ResistorConfig.series)
                            Text("Parallel").tag(ResistorConfig.parallel)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Resistor Values (Ω)") {
                        TextField("R₁", text: $r1)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($r1)
                        TextField("R₂", text: $r2)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($r2)
                        TextField("R₃", text: $r3)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($r3)
                    }
                    
                    if let totalResistance {
                        Section("Result") {
                            let resultStr = String(format: "%.4g Ω", totalResistance)
                            ResultWithActionsView(result: resultStr, fullText: (steps + ["R_total = \(resultStr)"]).joined(separator: "\n"))
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "R_total = %.4g Ω", totalResistance)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Resistors")
    }
}

#Preview {
    NavigationStack {
        ResistorView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
