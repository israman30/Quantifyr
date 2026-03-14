//
//  ForceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct ForceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var acceleration = ""
    @State private var hasCalculated = false
    
    private var force: Double? {
        guard let m = Double(mass), let a = Double(acceleration) else { return nil }
        return m * a
    }
    
    private var resultString: String? {
        guard let f = force else { return nil }
        return "F = \(String(format: "%.4g", f)) N"
    }
    
    private var steps: [String] {
        guard let _ = force, let m = Double(mass), let a = Double(acceleration) else { return [] }
        return [
            "Given: m = \(m) kg, a = \(a) m/s²",
            "F = m × a",
            "F = \(m) × \(a)"
        ]
    }
    
    private var canCalculate: Bool { force != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "F = m × a",
                    variables: ["F = Force (N)", "m = Mass (kg)", "a = Acceleration (m/s²)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                        TextField("Acceleration (m/s²)", text: $acceleration)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Force", result: str)
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
                            Text(resultString)
                                .font(.title2)
                                .fontWeight(.semibold)
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
        .navigationTitle("Force")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("force")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("force") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("force") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ForceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
