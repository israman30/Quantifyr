//
//  PhysicsPowerView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct PhysicsPowerView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var work = ""
    @State private var time = ""
    @State private var hasCalculated = false
    
    private var power: Double? {
        guard let w = Double(work), let t = Double(time), t != 0 else { return nil }
        return w / t
    }
    
    private var resultString: String? {
        guard let p = power else { return nil }
        return "P = \(String(format: "%.4g", p)) W"
    }
    
    private var steps: [String] {
        guard let _ = power, let w = Double(work), let t = Double(time) else { return [] }
        return [
            "Given: W = \(w) J, t = \(t) s",
            "P = W / t",
            "P = \(w) / \(t)"
        ]
    }
    
    private var canCalculate: Bool { power != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "P = W / t",
                    variables: ["P = Power (W)", "W = Work (J)", "t = Time (s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Work (J)", text: $work)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($work)
                        TextField("Time (s)", text: $time)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($time)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Power", result: str)
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
        .navigationTitle("Power")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("physics_power")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("physics_power") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("physics_power") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhysicsPowerView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
