//
//  MomentumView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct MomentumView: View {
    @State private var mass = ""
    @State private var velocity = ""
    
    private var momentum: Double? {
        guard let m = Double(mass), let v = Double(velocity) else { return nil }
        return m * v
    }
    
    private var steps: [String] {
        guard let p = momentum, let m = Double(mass), let v = Double(velocity) else { return [] }
        return [
            "Given: m = \(m) kg, v = \(v) m/s",
            "p = mv",
            "p = \(m) × \(v)"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "p = mv",
                    variables: ["p = Momentum (kg·m/s)", "m = Mass (kg)", "v = Velocity (m/s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let momentum {
                        Section("Result") {
                            Text(String(format: "%.4g kg·m/s", momentum))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "p = %.4g kg·m/s", momentum)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Momentum")
    }
}

#Preview {
    NavigationStack {
        MomentumView()
    }
}
