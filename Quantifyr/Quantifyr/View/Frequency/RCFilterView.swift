//
//  RCFilterView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct RCFilterView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var resistance = ""
    @State private var capacitance = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var cutoffFrequency: Double? {
        guard let r = Double(resistance), let c = Double(capacitance),
              r > 0, c > 0 else { return nil }
        return 1 / (2 * pi * r * c)
    }
    
    private var resultString: String? {
        guard let f = cutoffFrequency else { return nil }
        return "f = \(String(format: "%.4g", f)) Hz"
    }
    
    private var steps: [String] {
        guard let _ = cutoffFrequency, let r = Double(resistance), let c = Double(capacitance) else { return [] }
        return [
            "Given: R = \(r) Ω, C = \(c) F",
            "f = 1 / (2πRC)",
            "f = 1 / (2 × π × \(r) × \(c))"
        ]
    }
    
    private var canCalculate: Bool { cutoffFrequency != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "f = 1 / (2πRC)",
                    variables: ["f = Cutoff frequency (Hz)", "R = Resistance (Ω)", "C = Capacitance (F)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Resistance (Ω)", text: $resistance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($resistance)
                        TextField("Capacitance (F)", text: $capacitance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($capacitance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "RC Filter", result: str)
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
        .navigationTitle("RC Filter")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("rc_filter")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("rc_filter") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("rc_filter") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RCFilterView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
