//
//  MomentumView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct MomentumView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mass = ""
    @State private var velocity = ""
    @State private var hasCalculated = false
    
    private var momentum: Double? {
        guard let m = Double(mass), let v = Double(velocity) else { return nil }
        return m * v
    }
    
    private var resultString: String? {
        guard let p = momentum else { return nil }
        return "p = \(String(format: "%.4g", p)) kg·m/s"
    }
    
    private var steps: [String] {
        guard let _ = momentum, let m = Double(mass), let v = Double(velocity) else { return [] }
        return [
            "Given: m = \(m) kg, v = \(v) m/s",
            "p = mv",
            "p = \(m) × \(v)"
        ]
    }
    
    private var canCalculate: Bool { momentum != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "p = mv",
                    variables: ["p = Momentum (kg·m/s)", "m = Mass (kg)", "v = Velocity (m/s)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Mass (kg)", text: $mass)
                            .keyboardType(.decimalPad)
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Momentum", result: str)
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
        .navigationTitle("Momentum")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("momentum")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("momentum") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("momentum") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MomentumView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
