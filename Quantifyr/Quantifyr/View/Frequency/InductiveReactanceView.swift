//
//  InductiveReactanceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct InductiveReactanceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var frequency = ""
    @State private var inductance = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var inductiveReactance: Double? {
        guard let f = Double(frequency), let l = Double(inductance) else { return nil }
        return 2 * pi * f * l
    }
    
    private var resultString: String? {
        guard let xl = inductiveReactance else { return nil }
        return "Xₗ = \(String(format: "%.4g", xl)) Ω"
    }
    
    private var steps: [String] {
        guard let _ = inductiveReactance, let f = Double(frequency), let l = Double(inductance) else { return [] }
        return [
            "Given: f = \(f) Hz, L = \(l) H",
            "Xₗ = 2πfL",
            "Xₗ = 2 × π × \(f) × \(l)"
        ]
    }
    
    private var canCalculate: Bool { inductiveReactance != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "Xₗ = 2πfL",
                    variables: ["Xₗ = Inductive reactance (Ω)", "f = Frequency (Hz)", "L = Inductance (H)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($frequency)
                        TextField("Inductance (H)", text: $inductance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($inductance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Inductive Reactance", result: str)
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
        .navigationTitle("Inductive Reactance")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("inductive_reactance")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("inductive_reactance") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("inductive_reactance") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InductiveReactanceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
