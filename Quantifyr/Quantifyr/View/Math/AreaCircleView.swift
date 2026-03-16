//
//  AreaCircleView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct AreaCircleView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var radius = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var area: Double? {
        guard let r = Double(radius), r >= 0 else { return nil }
        return pi * r * r
    }
    
    private var resultString: String? {
        guard let a = area else { return nil }
        return "A = \(String(format: "%.4g", a))"
    }
    
    private var steps: [String] {
        guard let _ = area, let r = Double(radius) else { return [] }
        return [
            "Given: r = \(r)",
            "A = πr²",
            "A = π × \(r)²"
        ]
    }
    
    private var canCalculate: Bool { area != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "A = πr²",
                    variables: ["A = Area", "r = Radius"]
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
                                historyManager.add(formulaName: "Area Circle", result: str)
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
        .navigationTitle("Area Circle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("area_circle")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("area_circle") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("area_circle") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AreaCircleView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
