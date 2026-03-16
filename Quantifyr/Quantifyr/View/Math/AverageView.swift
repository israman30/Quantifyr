//
//  AverageView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct AverageView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var valuesInput = ""
    @State private var hasCalculated = false
    
    private var values: [Double] {
        valuesInput
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
    }
    
    private var average: Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }
    
    private var resultString: String? {
        guard let mean = average else { return nil }
        return "mean = \(String(format: "%.4g", mean))"
    }
    
    private var steps: [String] {
        guard let _ = average, !values.isEmpty else { return [] }
        let sum = values.reduce(0, +)
        let n = values.count
        return [
            "Given: n = \(n) values",
            "Σx = \(sum)",
            "mean = Σx / n = \(sum) / \(n)"
        ]
    }
    
    private var canCalculate: Bool { average != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "mean = Σx / n",
                    variables: ["mean = Average", "Σx = Sum of values", "n = Count"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Numbers (comma-separated)", text: $valuesInput)
                            .keyboardType(.numbersAndPunctuation)
                        if !values.isEmpty {
                            Text("\(values.count) value(s) entered")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Average", result: str)
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
        .navigationTitle("Average")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("average")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("average") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("average") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AverageView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
