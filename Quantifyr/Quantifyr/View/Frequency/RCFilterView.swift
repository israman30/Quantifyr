//
//  RCFilterView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum RCFormula: String, CaseIterable {
    case cutoffFrequency = "f = 1 / (2πRC)"
    case timeConstant = "τ = R × C"
}

struct RCFilterView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var formula: RCFormula = .cutoffFrequency
    @State private var resistance = ""
    @State private var capacitance = ""
    @State private var hasCalculated = false
    
    private let pi = Double.pi
    
    private var cutoffFrequency: Double? {
        guard let r = Double(resistance), let c = Double(capacitance),
              r > 0, c > 0 else { return nil }
        return 1 / (2 * pi * r * c)
    }
    
    private var timeConstant: Double? {
        guard let r = Double(resistance), let c = Double(capacitance),
              r > 0, c > 0 else { return nil }
        return r * c
    }
    
    private var resultString: String? {
        switch formula {
        case .cutoffFrequency:
            guard let f = cutoffFrequency else { return nil }
            return "f = \(String(format: "%.4g", f)) Hz"
        case .timeConstant:
            guard let tau = timeConstant else { return nil }
            return "τ = \(String(format: "%.4g", tau)) s"
        }
    }
    
    private var steps: [String] {
        guard let r = Double(resistance), let c = Double(capacitance), r > 0, c > 0 else { return [] }
        switch formula {
        case .cutoffFrequency:
            guard cutoffFrequency != nil else { return [] }
            return [
                "Given: R = \(r) Ω, C = \(c) F",
                "f = 1 / (2πRC)",
                "f = 1 / (2 × π × \(r) × \(c))"
            ]
        case .timeConstant:
            guard timeConstant != nil else { return [] }
            return [
                "Given: R = \(r) Ω, C = \(c) F",
                "τ = R × C",
                "τ = \(r) × \(c)"
            ]
        }
    }
    
    private var canCalculate: Bool {
        switch formula {
        case .cutoffFrequency: return cutoffFrequency != nil
        case .timeConstant: return timeConstant != nil
        }
    }
    
    private var formulaVariables: [String] {
        switch formula {
        case .cutoffFrequency:
            return ["f = Cutoff frequency (Hz)", "R = Resistance (Ω)", "C = Capacitance (F)"]
        case .timeConstant:
            return ["τ = Time constant (s)", "R = Resistance (Ω)", "C = Capacitance (F)"]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: formula.rawValue,
                    variables: formulaVariables
                )
                
                Form {
                    Section("Formula") {
                        Picker("Mode", selection: $formula) {
                            ForEach(RCFormula.allCases, id: \.self) { f in
                                Text(f.rawValue).tag(f)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Input Values") {
                        TextField("Resistance (Ω)", text: $resistance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($resistance)
                        TextField("Capacitance (F)", text: $capacitance)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($capacitance)
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                let name = formula == .timeConstant ? "RC Time Constant" : "RC Filter"
                                historyManager.add(formulaName: name, result: str)
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
        .navigationTitle("RC Filter")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("rc_filter")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("rc_filter") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("rc_filter") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RCFilterView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
