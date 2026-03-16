//
//  SlopeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct SlopeView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var x1 = ""
    @State private var y1 = ""
    @State private var x2 = ""
    @State private var y2 = ""
    @State private var hasCalculated = false
    
    private var slope: Double? {
        guard let x1v = Double(x1), let y1v = Double(y1),
              let x2v = Double(x2), let y2v = Double(y2),
              x2v != x1v else { return nil }
        return (y2v - y1v) / (x2v - x1v)
    }
    
    private var resultString: String? {
        guard let m = slope else { return nil }
        return "m = \(String(format: "%.4g", m))"
    }
    
    private var steps: [String] {
        guard let _ = slope, let x1v = Double(x1), let y1v = Double(y1), let x2v = Double(x2), let y2v = Double(y2) else { return [] }
        return [
            "Given: (x₁,y₁) = (\(x1v),\(y1v)), (x₂,y₂) = (\(x2v),\(y2v))",
            "m = (y₂ - y₁)/(x₂ - x₁)",
            "m = (\(y2v) - \(y1v))/(\(x2v) - \(x1v))"
        ]
    }
    
    private var canCalculate: Bool { slope != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "m = (y₂ - y₁)/(x₂ - x₁)",
                    variables: ["m = Slope", "x₁,y₁ = Point 1", "x₂,y₂ = Point 2"]
                )
                
                Form {
                    Section("Point 1") {
                        TextField("x₁", text: $x1)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($x1)
                        TextField("y₁", text: $y1)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($y1)
                    }
                    Section("Point 2") {
                        TextField("x₂", text: $x2)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($x2)
                        TextField("y₂", text: $y2)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($y2)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Slope", result: str)
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
        .navigationTitle("Slope")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("slope")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("slope") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("slope") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SlopeView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
