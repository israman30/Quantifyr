//
//  QuadraticFormulaView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct QuadraticFormulaView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var a = ""
    @State private var b = ""
    @State private var c = ""
    @State private var hasCalculated = false
    
    private var discriminant: Double? {
        guard let av = Double(a), let bv = Double(b), let cv = Double(c), av != 0 else { return nil }
        return bv * bv - 4 * av * cv
    }
    
    private var solutions: (x1: Double, x2: Double)? {
        guard let av = Double(a), let bv = Double(b), let _ = Double(c),
              av != 0, let d = discriminant, d >= 0 else { return nil }
        let sqrtD = d.squareRoot()
        let x1 = (-bv + sqrtD) / (2 * av)
        let x2 = (-bv - sqrtD) / (2 * av)
        return (x1, x2)
    }
    
    private var resultString: String? {
        guard let av = Double(a), av != 0 else { return nil }
        guard let d = discriminant else { return nil }
        if d < 0 {
            return "No real solutions (discriminant < 0)"
        }
        guard let sol = solutions else { return nil }
        if d == 0 {
            return "x = \(String(format: "%.4g", sol.x1))"
        }
        return "x₁ = \(String(format: "%.4g", sol.x1)), x₂ = \(String(format: "%.4g", sol.x2))"
    }
    
    private var steps: [String] {
        guard let av = Double(a), let bv = Double(b), let cv = Double(c), av != 0 else { return [] }
        guard let d = discriminant, d >= 0, let sol = solutions else { return [] }
        var s = [
            "Given: a = \(av), b = \(bv), c = \(cv)",
            "Discriminant: b² - 4ac = \(bv)² - 4(\(av))(\(cv)) = \(d)",
            "x = (-b ± √(b²-4ac)) / 2a"
        ]
        if d == 0 {
            s.append("x = \(String(format: "%.4g", sol.x1))")
        } else {
            s.append("x₁ = \(String(format: "%.4g", sol.x1))")
            s.append("x₂ = \(String(format: "%.4g", sol.x2))")
        }
        return s
    }
    
    private var canCalculate: Bool {
        guard let av = Double(a), av != 0,
              Double(b) != nil, Double(c) != nil else { return false }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "x = (-b ± √(b²-4ac)) / 2a",
                    variables: ["a, b, c = Coefficients of ax² + bx + c = 0"]
                )
                
                Form {
                    Section("Coefficients (ax² + bx + c = 0)") {
                        TextField("a", text: $a)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($a)
                        TextField("b", text: $b)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($b)
                        TextField("c", text: $c)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($c)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Quadratic Formula", result: str)
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
                        if let _ = solutions {
                            Section {
                                StepByStepView(steps: steps, result: resultString)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Quadratic Formula")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("quadratic_formula")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("quadratic_formula") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("quadratic_formula") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuadraticFormulaView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
