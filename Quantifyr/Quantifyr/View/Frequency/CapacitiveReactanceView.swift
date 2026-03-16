//
//  CapacitiveReactanceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct CapacitiveReactanceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var frequency = ""
    @State private var capacitance = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var capacitiveReactance: Double? {
        guard let f = Double(frequency), let c = Double(capacitance),
              f != 0, c != 0 else { return nil }
        return 1 / (2 * pi * f * c)
    }
    
    private var resultString: String? {
        guard let xc = capacitiveReactance else { return nil }
        return "Xc = \(String(format: "%.4g", xc)) Ω"
    }
    
    private var steps: [String] {
        guard let _ = capacitiveReactance, let f = Double(frequency), let c = Double(capacitance) else { return [] }
        return [
            "Given: f = \(f) Hz, C = \(c) F",
            "Xc = 1 / (2πfC)",
            "Xc = 1 / (2 × π × \(f) × \(c))"
        ]
    }
    
    private var canCalculate: Bool { capacitiveReactance != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "Xc = 1 / (2πfC)",
                    variables: ["Xc = Capacitive reactance (Ω)", "f = Frequency (Hz)", "C = Capacitance (F)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($frequency)
                        TextField("Capacitance (F)", text: $capacitance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($capacitance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Capacitive Reactance", result: str)
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
        .navigationTitle("Capacitive Reactance")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("capacitive_reactance")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("capacitive_reactance") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("capacitive_reactance") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CapacitiveReactanceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
