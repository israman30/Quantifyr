//
//  WaveSpeedView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct WaveSpeedView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var frequency = ""
    @State private var wavelength = ""
    @State private var hasCalculated = false
    
    private var waveSpeed: Double? {
        guard let f = Double(frequency), let lambda = Double(wavelength) else { return nil }
        return f * lambda
    }
    
    private var resultString: String? {
        guard let v = waveSpeed else { return nil }
        return "v = \(String(format: "%.4g", v)) m/s"
    }
    
    private var steps: [String] {
        guard let _ = waveSpeed, let f = Double(frequency), let lambda = Double(wavelength) else { return [] }
        return [
            "Given: f = \(f) Hz, λ = \(lambda) m",
            "v = fλ",
            "v = \(f) × \(lambda)"
        ]
    }
    
    private var canCalculate: Bool { waveSpeed != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "v = fλ",
                    variables: ["v = Wave speed (m/s)", "f = Frequency (Hz)", "λ = Wavelength (m)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($frequency)
                        TextField("Wavelength (m)", text: $wavelength)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($wavelength)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Wave Speed", result: str)
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
        .navigationTitle("Wave Speed")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("wave_speed")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("wave_speed") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("wave_speed") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WaveSpeedView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
