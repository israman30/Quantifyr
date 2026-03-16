//
//  FrequencyPeriodView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

enum FrequencyPeriodMode: String, CaseIterable {
    case frequency = "f = 1 / T"
    case period = "T = 1 / f"
}

struct FrequencyPeriodView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var mode: FrequencyPeriodMode = .frequency
    @State private var frequency = ""
    @State private var period = ""
    @State private var hasCalculated = false
    
    private var result: Double? {
        switch mode {
        case .frequency:
            guard let t = Double(period), t != 0 else { return nil }
            return 1 / t
        case .period:
            guard let f = Double(frequency), f != 0 else { return nil }
            return 1 / f
        }
    }
    
    private var resultString: String? {
        guard let r = result else { return nil }
        switch mode {
        case .frequency: return "f = \(String(format: "%.4g", r)) Hz"
        case .period: return "T = \(String(format: "%.4g", r)) s"
        }
    }
    
    private var steps: [String] {
        guard result != nil else { return [] }
        switch mode {
        case .frequency:
            guard let t = Double(period) else { return [] }
            return [
                "Given: T = \(t) s",
                "f = 1 / T",
                "f = 1 / \(t)"
            ]
        case .period:
            guard let f = Double(frequency) else { return [] }
            return [
                "Given: f = \(f) Hz",
                "T = 1 / f",
                "T = 1 / \(f)"
            ]
        }
    }
    
    private var canCalculate: Bool { result != nil }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: mode.rawValue,
                    variables: mode == .frequency
                        ? ["f = Frequency (Hz)", "T = Period (s)"]
                        : ["T = Period (s)", "f = Frequency (Hz)"]
                )
                
                Form {
                    Section("Formula") {
                        Picker("Solve for", selection: $mode) {
                            Text("Frequency (f)").tag(FrequencyPeriodMode.frequency)
                            Text("Period (T)").tag(FrequencyPeriodMode.period)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Input Values") {
                        if mode == .frequency {
                            TextField("Period T (s)", text: $period)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($period)
                        } else {
                            TextField("Frequency f (Hz)", text: $frequency)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($frequency)
                        }
                    }
                    
                    Section {
                        Button {
                            hasCalculated = true
                            if let str = resultString {
                                let name = mode == .frequency ? "Frequency" : "Period"
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
        .navigationTitle("Frequency & Period")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("frequency_period")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("frequency_period") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("frequency_period") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FrequencyPeriodView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
