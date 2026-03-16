//
//  CircumferenceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct CircumferenceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var radius = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var circumference: Double? {
        guard let r = Double(radius), r >= 0 else { return nil }
        return 2 * pi * r
    }
    
    private var resultString: String? {
        guard let c = circumference else { return nil }
        return "C = \(String(format: "%.4g", c))"
    }
    
    private var steps: [String] {
        guard let _ = circumference, let r = Double(radius) else { return [] }
        return [
            "Given: r = \(r)",
            "C = 2πr",
            "C = 2 × π × \(r)"
        ]
    }
    
    private var canCalculate: Bool { circumference != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "C = 2πr",
                    variables: ["C = Circumference", "r = Radius"]
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
                                historyManager.add(formulaName: "Circumference", result: str)
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
        .navigationTitle("Circumference")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("circumference")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("circumference") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("circumference") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CircumferenceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
