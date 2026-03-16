//
//  CentripetalForceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct CentripetalForceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var velocity = ""
    @State private var radius = ""
    @State private var hasCalculated = false
    
    private var centripetalForce: Double? {
        guard let m = Double(mass), let v = Double(velocity), let r = Double(radius), r != 0 else { return nil }
        return m * v * v / r
    }
    
    private var resultString: String? {
        guard let f = centripetalForce else { return nil }
        return "F = \(String(format: "%.4g", f)) N"
    }
    
    private var steps: [String] {
        guard let _ = centripetalForce, let m = Double(mass), let v = Double(velocity), let r = Double(radius) else { return [] }
        return [
            "Given: m = \(m) kg, v = \(v) m/s, r = \(r) m",
            "F = mv² / r",
            "F = \(m) × \(v)² / \(r)"
        ]
    }
    
    private var canCalculate: Bool { centripetalForce != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "F = mv² / r",
                    variables: ["F = Centripetal Force (N)", "m = Mass (kg)", "v = Velocity (m/s)", "r = Radius (m)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($mass)
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($velocity)
                        TextField("Radius (m)", text: $radius)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($radius)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Centripetal Force", result: str)
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
        .navigationTitle("Centripetal Force")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("centripetal_force")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("centripetal_force") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("centripetal_force") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CentripetalForceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
