//
//  WavelengthView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct WavelengthView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var velocity = ""
    @State private var frequency = ""
    @State private var hasCalculated = false
    
    private var wavelength: Double? {
        guard let v = Double(velocity), let f = Double(frequency), f != 0 else { return nil }
        return v / f
    }
    
    private var resultString: String? {
        guard let w = wavelength else { return nil }
        return "λ = \(String(format: "%.4g", w)) m"
    }
    
    private var steps: [String] {
        guard let _ = wavelength, let v = Double(velocity), let f = Double(frequency) else { return [] }
        return [
            "Given: v = \(v) m/s, f = \(f) Hz",
            "λ = v / f",
            "λ = \(v) / \(f)"
        ]
    }
    
    private var canCalculate: Bool { wavelength != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "λ = v / f",
                    variables: ["λ = Wavelength (m)", "v = Wave velocity (m/s)", "f = Frequency (Hz)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($velocity)
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($frequency)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Wavelength", result: str)
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
        .navigationTitle("Wavelength")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("wavelength")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("wavelength") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("wavelength") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WavelengthView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
