//
//  VolumeCylinderView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct VolumeCylinderView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var radius = ""
    @State private var height = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var volume: Double? {
        guard let r = Double(radius), let h = Double(height), r >= 0, h >= 0 else { return nil }
        return pi * r * r * h
    }
    
    private var resultString: String? {
        guard let v = volume else { return nil }
        return "V = \(String(format: "%.4g", v))"
    }
    
    private var steps: [String] {
        guard let _ = volume, let r = Double(radius), let h = Double(height) else { return [] }
        return [
            "Given: r = \(r), h = \(h)",
            "V = πr²h",
            "V = π × \(r)² × \(h)"
        ]
    }
    
    private var canCalculate: Bool { volume != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "V = πr²h",
                    variables: ["V = Volume", "r = Radius", "h = Height"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Radius (r)", text: $radius)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($radius)
                        TextField("Height (h)", text: $height)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($height)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Volume Cylinder", result: str)
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
        .navigationTitle("Volume Cylinder")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("volume_cylinder")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("volume_cylinder") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("volume_cylinder") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VolumeCylinderView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
