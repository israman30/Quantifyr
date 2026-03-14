//
//  KineticEnergyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct KineticEnergyView: View {
    @State private var mass = ""
    @State private var velocity = ""
    
    private var kineticEnergy: Double? {
        guard let m = Double(mass), let v = Double(velocity) else { return nil }
        return 0.5 * m * v * v
    }
    
    private var steps: [String] {
        guard let _ = kineticEnergy, let m = Double(mass), let v = Double(velocity) else { return [] }
        return [
            "Given: m = \(m) kg, v = \(v) m/s",
            "E = ½mv²",
            "E = ½ × \(m) × \(v)²"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "E = ½mv²",
                    variables: ["E = Kinetic Energy (J)", "m = Mass (kg)", "v = Velocity (m/s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let kineticEnergy {
                        Section("Result") {
                            Text(String(format: "%.4g J", kineticEnergy))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "E = %.4g J", kineticEnergy)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Kinetic Energy")
    }
}

#Preview {
    NavigationStack {
        KineticEnergyView()
    }
}
