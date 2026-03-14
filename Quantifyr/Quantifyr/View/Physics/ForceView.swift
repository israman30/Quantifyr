//
//  ForceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct ForceView: View {
    @State private var mass = ""
    @State private var acceleration = ""
    
    private var force: Double? {
        guard let m = Double(mass), let a = Double(acceleration) else { return nil }
        return m * a
    }
    
    private var steps: [String] {
        guard let _ = force, let m = Double(mass), let a = Double(acceleration) else { return [] }
        return [
            "Given: m = \(m) kg, a = \(a) m/s²",
            "F = m × a",
            "F = \(m) × \(a)"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "F = m × a",
                    variables: ["F = Force (N)", "m = Mass (kg)", "a = Acceleration (m/s²)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                        TextField("Acceleration (m/s²)", text: $acceleration)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let force {
                        Section("Result") {
                            Text(String(format: "%.4g N", force))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "F = %.4g N", force)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Force")
    }
}

#Preview {
    NavigationStack {
        ForceView()
    }
}
