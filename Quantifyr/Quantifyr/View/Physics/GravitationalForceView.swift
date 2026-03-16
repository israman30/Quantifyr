//
//  GravitationalForceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct GravitationalForceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass1 = ""
    @State private var mass2 = ""
    @State private var distance = ""
    @State private var hasCalculated = false
    
    private let G = 6.674e-11  // Gravitational constant (N⋅m²/kg²)
    
    private var gravitationalForce: Double? {
        guard let m1 = Double(mass1), let m2 = Double(mass2), let r = Double(distance), r != 0 else { return nil }
        return G * m1 * m2 / (r * r)
    }
    
    private var resultString: String? {
        guard let f = gravitationalForce else { return nil }
        return "F = \(String(format: "%.4g", f)) N"
    }
    
    private var steps: [String] {
        guard let _ = gravitationalForce, let m1 = Double(mass1), let m2 = Double(mass2), let r = Double(distance) else { return [] }
        return [
            "Given: m₁ = \(m1) kg, m₂ = \(m2) kg, r = \(r) m",
            "F = G(m₁m₂)/r²",
            "F = 6.674×10⁻¹¹ × \(m1) × \(m2) / \(r)²"
        ]
    }
    
    private var canCalculate: Bool { gravitationalForce != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "F = G(m₁m₂)/r²",
                    variables: ["F = Gravitational Force (N)", "G = 6.674×10⁻¹¹ N⋅m²/kg²", "m₁, m₂ = Masses (kg)", "r = Distance (m)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass 1 (kg)", text: $mass1)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($mass1)
                        TextField("Mass 2 (kg)", text: $mass2)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($mass2)
                        TextField("Distance (m)", text: $distance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($distance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Gravitational Force", result: str)
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
                            ResultWithActionsView(result: resultString, fullText: (steps + [resultString]).joined(separator: "\n"))
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
        .navigationTitle("Gravitational Force")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("gravitational_force")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("gravitational_force") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("gravitational_force") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GravitationalForceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
