//
//  KineticEnergyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct KineticEnergyView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var velocity = ""
    @State private var hasCalculated = false
    
    private var kineticEnergy: Double? {
        guard let m = Double(mass), let v = Double(velocity) else { return nil }
        return 0.5 * m * v * v
    }
    
    private var resultString: String? {
        guard let e = kineticEnergy else { return nil }
        return "E = \(String(format: "%.4g", e)) J"
    }
    
    private var steps: [String] {
        guard let _ = kineticEnergy, let m = Double(mass), let v = Double(velocity) else { return [] }
        return [
            "Given: m = \(m) kg, v = \(v) m/s",
            "E = ½mv²",
            "E = ½ × \(m) × \(v)²"
        ]
    }
    
    private var canCalculate: Bool { kineticEnergy != nil }
    
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
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Kinetic Energy", result: str)
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
                            Text(resultString)
                                .font(.title2)
                                .fontWeight(.semibold)
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
        .navigationTitle("Kinetic Energy")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("kinetic_energy")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("kinetic_energy") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("kinetic_energy") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        KineticEnergyView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
