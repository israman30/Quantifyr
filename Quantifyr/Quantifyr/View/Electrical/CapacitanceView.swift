//
//  CapacitanceView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum CapacitorConfig: String, CaseIterable {
    case parallel = "Parallel"
    case series = "Series"
}

enum CapacitorFormula: String, CaseIterable {
    case combined = "Combined (Series/Parallel)"
    case charge = "Q = C × V"
    case energy = "E = ½ C V²"
}

struct CapacitanceView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var formulaMode: CapacitorFormula = .combined
    @State private var config: CapacitorConfig = .parallel
    @State private var c1 = ""
    @State private var c2 = ""
    @State private var c3 = ""
    @State private var capacitance = ""
    @State private var voltage = ""
    @State private var hasCalculated = false
    
    private var totalCapacitance: Double? {
        let values = [c1, c2, c3].compactMap { Double($0) }.filter { $0 > 0 }
        guard !values.isEmpty else { return nil }
        
        switch config {
        case .parallel:
            return values.reduce(0, +)
        case .series:
            let invSum = values.map { 1 / $0 }.reduce(0, +)
            return invSum > 0 ? 1 / invSum : nil
        }
    }
    
    private var chargeResult: Double? {
        guard formulaMode == .charge,
              let c = Double(capacitance), let v = Double(voltage),
              c > 0 else { return nil }
        return c * v
    }
    
    private var energyResult: Double? {
        guard formulaMode == .energy,
              let c = Double(capacitance), let v = Double(voltage),
              c > 0 else { return nil }
        return 0.5 * c * v * v
    }
    
    private var formula: String {
        switch formulaMode {
        case .combined:
            return config == .parallel ? "C_total = C₁ + C₂ + C₃ + ..." : "1/C_total = 1/C₁ + 1/C₂ + 1/C₃ + ..."
        case .charge:
            return "Q = C × V"
        case .energy:
            return "E = ½ C V²"
        }
    }
    
    private var variables: [String] {
        switch formulaMode {
        case .combined:
            return ["C_total = Total capacitance (F)"]
        case .charge:
            return ["Q = Charge (C)", "C = Capacitance (F)", "V = Voltage (V)"]
        case .energy:
            return ["E = Energy (J)", "C = Capacitance (F)", "V = Voltage (V)"]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: formula,
                    variables: variables
                )
                
                Form {
                    Section("Formula") {
                        Picker("Mode", selection: $formulaMode) {
                            ForEach(CapacitorFormula.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    if formulaMode == .combined {
                        Section("Configuration") {
                            Picker("Type", selection: $config) {
                                Text("Parallel").tag(CapacitorConfig.parallel)
                                Text("Series").tag(CapacitorConfig.series)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Section("Capacitor Values (F)") {
                            TextField("C₁", text: $c1)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($c1)
                            TextField("C₂", text: $c2)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($c2)
                            TextField("C₃", text: $c3)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($c3)
                        }
                        
                        if let totalCapacitance {
                            Section("Result") {
                                ResultWithActionsView(result: String(format: "%.6g F", totalCapacitance))
                            }
                        }
                    } else {
                        Section("Input Values") {
                            TextField("Capacitance (F)", text: $capacitance)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($capacitance)
                            TextField("Voltage (V)", text: $voltage)
                                .keyboardType(.decimalPad)
                                .validatedDecimalInput($voltage)
                        }
                        
                        Section {
                            Button {
                                hasCalculated = true
                                if let q = chargeResult {
                                    historyManager.add(formulaName: "Capacitor Charge", result: String(format: "%.4g C", q))
                                } else if let e = energyResult {
                                    historyManager.add(formulaName: "Capacitor Energy", result: String(format: "%.4g J", e))
                                }
                            } label: {
                                Text("Calculate")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(chargeResult == nil && energyResult == nil)
                        }
                        
                        if hasCalculated, let q = chargeResult {
                            Section("Result") {
                                ResultWithActionsView(result: String(format: "%.4g C", q), fullText: "Q = C × V\n\(String(format: "%.4g C", q))")
                            }
                        } else if hasCalculated, let e = energyResult {
                            Section("Result") {
                                ResultWithActionsView(result: String(format: "%.4g J", e), fullText: "E = ½ C V²\n\(String(format: "%.4g J", e))")
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Capacitance")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("capacitance")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("capacitance") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("capacitance") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CapacitanceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
