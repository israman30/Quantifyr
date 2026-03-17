//
//  OhmsLawView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum OhmsLawSolveFor: String, CaseIterable {
    case voltage = "Voltage (V)"
    case current = "Current (I)"
    case resistance = "Resistance (R)"
}

// Color coding for students: Voltage → Blue, Current → Green, Resistance → Orange
private enum OhmsLawColor {
    static let voltage = Color.blue
    static let current = Color.green
    static let resistance = Color.orange
}

struct OhmsLawView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var solveFor: OhmsLawSolveFor = .current
    @State private var voltage = ""
    @State private var current = ""
    @State private var resistance = ""
    @State private var hasCalculated = false
    
    private var result: (value: Double, unit: String)? {
        switch solveFor {
        case .voltage:
            guard let i = Double(current), let r = Double(resistance), r != 0 else { return nil }
            return (i * r, "V")
        case .current:
            guard let v = Double(voltage), let r = Double(resistance), r != 0 else { return nil }
            return (v / r, "A")
        case .resistance:
            guard let v = Double(voltage), let i = Double(current), i != 0 else { return nil }
            return (v / i, "Ω")
        }
    }
    
    private var resultString: String? {
        guard let r = result else { return nil }
        let unitName = r.unit == "A" ? "Amps" : (r.unit == "V" ? "Volts" : "Ohms")
        return "\(solveFor == .current ? "I" : (solveFor == .voltage ? "V" : "R")) = \(String(format: "%.4g", r.value)) \(unitName)"
    }
    
    private var steps: [String] {
        guard result != nil else { return [] }
        switch solveFor {
        case .voltage:
            guard let i = Double(current), let res = Double(resistance) else { return [] }
            return [
                "V = I × R",
                "V = \(i) × \(res)"
            ]
        case .current:
            guard let v = Double(voltage), let res = Double(resistance) else { return [] }
            return [
                "I = V / R",
                "I = \(v) / \(res)"
            ]
        case .resistance:
            guard let v = Double(voltage), let i = Double(current) else { return [] }
            return [
                "R = V / I",
                "R = \(v) / \(i)"
            ]
        }
    }
    
    private var canCalculate: Bool {
        switch solveFor {
        case .voltage: return Double(current) != nil && Double(resistance) != nil && (Double(resistance) ?? 0) != 0
        case .current: return Double(voltage) != nil && Double(resistance) != nil && (Double(resistance) ?? 0) != 0
        case .resistance: return Double(voltage) != nil && Double(current) != nil && (Double(current) ?? 0) != 0
        }
    }
    
    private var displayedFormula: String {
        switch solveFor {
        case .voltage: return "V = I × R"
        case .current: return "I = V / R"
        case .resistance: return "R = V / I"
        }
    }
    
    private var resultDisplay: String? {
        guard let r = result else { return nil }
        let unitName = r.unit == "A" ? "Amps" : (r.unit == "V" ? "Volts" : "Ohms")
        return "\(String(format: "%.4g", r.value)) \(unitName)"
    }
    
    var body: some View {
        FormulaDetailView(
            title: "Ohm's Law",
            formula: displayedFormula,
            onCalculate: {
                hasCalculated = true
                if let str = resultString {
                    historyManager.add(formulaName: "Ohm's Law", result: str)
                }
            },
            canCalculate: canCalculate,
            result: hasCalculated ? resultDisplay : nil,
            steps: hasCalculated ? steps : nil,
            stepsResult: hasCalculated ? resultString : nil,
            inputContent: {
                VStack(spacing: 12) {
                    if solveFor != .voltage {
                        TextField("Voltage (V)", text: $voltage)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(OhmsLawColor.voltage)
                            .validatedDecimalInput($voltage)
                            .textFieldStyle(.roundedBorder)
                    }
                    if solveFor != .current {
                        TextField("Current (A)", text: $current)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(OhmsLawColor.current)
                            .validatedDecimalInput($current)
                            .textFieldStyle(.roundedBorder)
                    }
                    if solveFor != .resistance {
                        TextField("Resistance (Ω)", text: $resistance)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(OhmsLawColor.resistance)
                            .validatedDecimalInput($resistance)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }, optionalContent: {
                Picker("Solve for", selection: $solveFor) {
                    ForEach(OhmsLawSolveFor.allCases, id: \.self) { opt in
                        Text(opt.rawValue).tag(opt)
                    }
                }
                .pickerStyle(.menu)
            }
        )
        .numericKeyboardToolbar()
        .navigationTitle("Ohm's Law")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("ohms_law")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("ohms_law") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("ohms_law") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OhmsLawView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
