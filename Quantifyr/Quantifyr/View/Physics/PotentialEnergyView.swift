//
//  PotentialEnergyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct PotentialEnergyView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var gravity = "9.81"
    @State private var height = ""
    @State private var hasCalculated = false
    
    private var potentialEnergy: Double? {
        guard let m = Double(mass), let g = Double(gravity), let h = Double(height) else { return nil }
        return m * g * h
    }
    
    private var resultString: String? {
        guard let pe = potentialEnergy else { return nil }
        return "PE = \(String(format: "%.4g", pe)) J"
    }
    
    private var steps: [String] {
        guard let _ = potentialEnergy, let m = Double(mass), let g = Double(gravity), let h = Double(height) else { return [] }
        return [
            "Given: m = \(m) kg, g = \(g) m/s², h = \(h) m",
            "PE = mgh",
            "PE = \(m) × \(g) × \(h)"
        ]
    }
    
    private var canCalculate: Bool { potentialEnergy != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "PE = mgh",
                    variables: ["PE = Potential Energy (J)", "m = Mass (kg)", "g = Gravity (m/s²)", "h = Height (m)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($mass)
                        TextField("Gravity (m/s²)", text: $gravity)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($gravity)
                        TextField("Height (m)", text: $height)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($height)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Potential Energy", result: str)
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
        .navigationTitle("Potential Energy")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("potential_energy")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("potential_energy") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("potential_energy") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PotentialEnergyView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
