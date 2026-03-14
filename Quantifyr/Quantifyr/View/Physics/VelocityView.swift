//
//  VelocityView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/14/26.
//

import SwiftUI

struct VelocityView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var distance = ""
    @State private var time = ""
    @State private var hasCalculated = false
    
    private var velocity: Double? {
        guard let d = Double(distance), let t = Double(time), t != 0 else { return nil }
        return d / t
    }
    
    private var resultString: String? {
        guard let v = velocity else { return nil }
        return "v = \(String(format: "%.4g", v)) m/s"
    }
    
    private var steps: [String] {
        guard let _ = velocity, let d = Double(distance), let t = Double(time) else { return [] }
        return [
            "Given: d = \(d) m, t = \(t) s",
            "v = d / t",
            "v = \(d) / \(t)"
        ]
    }
    
    private var canCalculate: Bool { velocity != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "v = d / t",
                    variables: ["v = Velocity (m/s)", "d = Distance (m)", "t = Time (s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Distance (m)", text: $distance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($distance)
                        TextField("Time (s)", text: $time)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($time)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Velocity", result: str)
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
        .navigationTitle("Velocity")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("velocity")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("velocity") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("velocity") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VelocityView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
