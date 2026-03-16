//
//  WorkView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct WorkView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var force = ""
    @State private var distance = ""
    @State private var hasCalculated = false
    
    private var work: Double? {
        guard let f = Double(force), let d = Double(distance) else { return nil }
        return f * d
    }
    
    private var resultString: String? {
        guard let w = work else { return nil }
        return "W = \(String(format: "%.4g", w)) J"
    }
    
    private var steps: [String] {
        guard let _ = work, let f = Double(force), let d = Double(distance) else { return [] }
        return [
            "Given: F = \(f) N, d = \(d) m",
            "W = F × d",
            "W = \(f) × \(d)"
        ]
    }
    
    private var canCalculate: Bool { work != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "W = F × d",
                    variables: ["W = Work (J)", "F = Force (N)", "d = Distance (m)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Force (N)", text: $force)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($force)
                        TextField("Distance (m)", text: $distance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($distance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Work", result: str)
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
        .navigationTitle("Work")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("work")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("work") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("work") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
