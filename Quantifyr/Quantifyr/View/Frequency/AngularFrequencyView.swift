//
//  AngularFrequencyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct AngularFrequencyView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var frequency = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var angularFrequency: Double? {
        guard let f = Double(frequency) else { return nil }
        return 2 * pi * f
    }
    
    private var resultString: String? {
        guard let omega = angularFrequency else { return nil }
        return "ω = \(String(format: "%.4g", omega)) rad/s"
    }
    
    private var steps: [String] {
        guard let _ = angularFrequency, let f = Double(frequency) else { return [] }
        return [
            "Given: f = \(f) Hz",
            "ω = 2πf",
            "ω = 2 × π × \(f)"
        ]
    }
    
    private var canCalculate: Bool { angularFrequency != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "ω = 2πf",
                    variables: ["ω = Angular frequency (rad/s)", "f = Frequency (Hz)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($frequency)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Angular Frequency", result: str)
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
        .navigationTitle("Angular Frequency")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("angular_frequency")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("angular_frequency") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("angular_frequency") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AngularFrequencyView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
