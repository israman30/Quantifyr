//
//  PressureView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct PressureView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var force = ""
    @State private var area = ""
    @State private var hasCalculated = false
    
    private var pressure: Double? {
        guard let f = Double(force), let a = Double(area), a != 0 else { return nil }
        return f / a
    }
    
    private var resultString: String? {
        guard let p = pressure else { return nil }
        return "P = \(String(format: "%.4g", p)) Pa"
    }
    
    private var steps: [String] {
        guard let _ = pressure, let f = Double(force), let a = Double(area) else { return [] }
        return [
            "Given: F = \(f) N, A = \(a) m²",
            "P = F / A",
            "P = \(f) / \(a)"
        ]
    }
    
    private var canCalculate: Bool { pressure != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "P = F / A",
                    variables: ["P = Pressure (Pa)", "F = Force (N)", "A = Area (m²)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Force (N)", text: $force)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($force)
                        TextField("Area (m²)", text: $area)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($area)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Pressure", result: str)
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
        .navigationTitle("Pressure")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("pressure")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("pressure") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("pressure") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PressureView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
