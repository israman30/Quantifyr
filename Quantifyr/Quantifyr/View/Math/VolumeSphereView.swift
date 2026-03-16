//
//  VolumeSphereView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct VolumeSphereView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var radius = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var volume: Double? {
        guard let r = Double(radius), r >= 0 else { return nil }
        return (4.0 / 3.0) * pi * r * r * r
    }
    
    private var resultString: String? {
        guard let v = volume else { return nil }
        return "V = \(String(format: "%.4g", v))"
    }
    
    private var steps: [String] {
        guard let _ = volume, let r = Double(radius) else { return [] }
        return [
            "Given: r = \(r)",
            "V = 4/3 πr³",
            "V = 4/3 × π × \(r)³"
        ]
    }
    
    private var canCalculate: Bool { volume != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "V = 4/3 πr³",
                    variables: ["V = Volume", "r = Radius"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Radius (r)", text: $radius)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($radius)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Volume Sphere", result: str)
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
                            StepByStepView(steps: steps, result: resultString)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Volume Sphere")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("volume_sphere")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("volume_sphere") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("volume_sphere") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VolumeSphereView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
