//
//  AccelerationView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct AccelerationView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var deltaVelocity = ""
    @State private var time = ""
    @State private var hasCalculated = false
    
    private var acceleration: Double? {
        guard let dv = Double(deltaVelocity), let t = Double(time), t != 0 else { return nil }
        return dv / t
    }
    
    private var resultString: String? {
        guard let a = acceleration else { return nil }
        return "a = \(String(format: "%.4g", a)) m/s²"
    }
    
    private var steps: [String] {
        guard let _ = acceleration, let dv = Double(deltaVelocity), let t = Double(time) else { return [] }
        return [
            "Given: Δv = \(dv) m/s, t = \(t) s",
            "a = Δv / t",
            "a = \(dv) / \(t)"
        ]
    }
    
    private var canCalculate: Bool { acceleration != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "a = Δv / t",
                    variables: ["a = Acceleration (m/s²)", "Δv = Change in velocity (m/s)", "t = Time (s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Change in velocity Δv (m/s)", text: $deltaVelocity)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($deltaVelocity)
                        TextField("Time (s)", text: $time)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($time)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Acceleration", result: str)
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
        .navigationTitle("Acceleration")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("acceleration")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("acceleration") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("acceleration") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccelerationView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
