//
//  RCFilterView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct RCFilterView: View {
    @State private var resistance = ""
    @State private var capacitance = ""
    
    private let pi = Double.pi
    
    private var cutoffFrequency: Double? {
        guard let r = Double(resistance), let c = Double(capacitance),
              r > 0, c > 0 else { return nil }
        return 1 / (2 * pi * r * c)
    }
    
    private var steps: [String] {
        guard let _ = cutoffFrequency, let r = Double(resistance), let c = Double(capacitance) else { return [] }
        return [
            "Given: R = \(r) Ω, C = \(c) F",
            "f = 1 / (2πRC)",
            "f = 1 / (2 × π × \(r) × \(c))"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "f = 1 / (2πRC)",
                    variables: ["f = Cutoff frequency (Hz)", "R = Resistance (Ω)", "C = Capacitance (F)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Resistance (Ω)", text: $resistance)
                            .keyboardType(.decimalPad)
                        TextField("Capacitance (F)", text: $capacitance)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let cutoffFrequency {
                        Section("Result") {
                            Text(String(format: "%.4g Hz", cutoffFrequency))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "f = %.4g Hz", cutoffFrequency)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("RC Filter")
    }
}

#Preview {
    NavigationStack {
        RCFilterView()
    }
}
