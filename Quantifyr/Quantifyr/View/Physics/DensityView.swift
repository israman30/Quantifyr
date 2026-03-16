//
//  DensityView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct DensityView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var volume = ""
    @State private var hasCalculated = false
    
    private var density: Double? {
        guard let m = Double(mass), let v = Double(volume), v != 0 else { return nil }
        return m / v
    }
    
    private var resultString: String? {
        guard let rho = density else { return nil }
        return "ρ = \(String(format: "%.4g", rho)) kg/m³"
    }
    
    private var steps: [String] {
        guard let _ = density, let m = Double(mass), let v = Double(volume) else { return [] }
        return [
            "Given: m = \(m) kg, V = \(v) m³",
            "ρ = m / V",
            "ρ = \(m) / \(v)"
        ]
    }
    
    private var canCalculate: Bool { density != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "ρ = m / V",
                    variables: ["ρ = Density (kg/m³)", "m = Mass (kg)", "V = Volume (m³)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($mass)
                        TextField("Volume (m³)", text: $volume)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($volume)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Density", result: str)
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
        .navigationTitle("Density")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("density")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("density") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("density") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DensityView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
