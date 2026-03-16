//
//  AreaTriangleView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct AreaTriangleView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var base = ""
    @State private var height = ""
    @State private var hasCalculated = false
    
    private var area: Double? {
        guard let b = Double(base), let h = Double(height) else { return nil }
        return 0.5 * b * h
    }
    
    private var resultString: String? {
        guard let a = area else { return nil }
        return "A = \(String(format: "%.4g", a))"
    }
    
    private var steps: [String] {
        guard let _ = area, let b = Double(base), let h = Double(height) else { return [] }
        return [
            "Given: b = \(b), h = \(h)",
            "A = ½bh",
            "A = ½ × \(b) × \(h)"
        ]
    }
    
    private var canCalculate: Bool { area != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "A = ½bh",
                    variables: ["A = Area", "b = Base", "h = Height"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Base (b)", text: $base)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($base)
                        TextField("Height (h)", text: $height)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($height)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Area Triangle", result: str)
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
        .navigationTitle("Area Triangle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("area_triangle")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("area_triangle") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("area_triangle") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AreaTriangleView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
