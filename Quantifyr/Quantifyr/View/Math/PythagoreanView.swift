//
//  PythagoreanView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

enum PythagoreanSolveFor: String, CaseIterable {
    case a = "Leg a"
    case b = "Leg b"
    case c = "Hypotenuse c"
}

struct PythagoreanView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var solveFor: PythagoreanSolveFor = .c
    @State private var a = ""
    @State private var b = ""
    @State private var c = ""
    @State private var hasCalculated = false
    
    private var result: Double? {
        switch solveFor {
        case .a:
            guard let bv = Double(b), let cv = Double(c), bv > 0, cv > 0, cv > bv else { return nil }
            return (cv * cv - bv * bv).squareRoot()
        case .b:
            guard let av = Double(a), let cv = Double(c), av > 0, cv > 0, cv > av else { return nil }
            return (cv * cv - av * av).squareRoot()
        case .c:
            guard let av = Double(a), let bv = Double(b), av > 0, bv > 0 else { return nil }
            return (av * av + bv * bv).squareRoot()
        }
    }
    
    private var resultString: String? {
        guard let r = result else { return nil }
        let symbol = solveFor == .a ? "a" : (solveFor == .b ? "b" : "c")
        return "\(symbol) = \(String(format: "%.4g", r))"
    }
    
    private var steps: [String] {
        guard let _ = result else { return [] }
        switch solveFor {
        case .a:
            guard let bv = Double(b), let cv = Double(c) else { return [] }
            return [
                "Given: b = \(bv), c = \(cv)",
                "a² = c² - b²",
                "a = √(\(cv)² - \(bv)²)"
            ]
        case .b:
            guard let av = Double(a), let cv = Double(c) else { return [] }
            return [
                "Given: a = \(av), c = \(cv)",
                "b² = c² - a²",
                "b = √(\(cv)² - \(av)²)"
            ]
        case .c:
            guard let av = Double(a), let bv = Double(b) else { return [] }
            return [
                "Given: a = \(av), b = \(bv)",
                "c² = a² + b²",
                "c = √(\(av)² + \(bv)²)"
            ]
        }
    }
    
    private var canCalculate: Bool { result != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "a² + b² = c²",
                    variables: ["a, b = Legs", "c = Hypotenuse"]
                )
                
                Form {
                    Section("Solve for") {
                        Picker("Find", selection: $solveFor) {
                            ForEach(PythagoreanSolveFor.allCases, id: \.self) { opt in
                                Text(opt.rawValue).tag(opt)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Input Values") {
                        if solveFor != .a {
                            TextField("Leg a", text: $a)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($a)
                        }
                        if solveFor != .b {
                            TextField("Leg b", text: $b)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($b)
                        }
                        if solveFor != .c {
                            TextField("Hypotenuse c", text: $c)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($c)
                        }
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                historyManager.add(formulaName: "Pythagorean", result: str)
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
        .navigationTitle("Pythagorean Theorem")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("pythagorean")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("pythagorean") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("pythagorean") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PythagoreanView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
