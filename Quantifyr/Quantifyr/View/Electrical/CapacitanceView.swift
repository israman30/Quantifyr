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

struct CapacitanceView: View {
    @State private var config: CapacitorConfig = .parallel
    @State private var c1 = ""
    @State private var c2 = ""
    @State private var c3 = ""
    
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
    
    private var formula: String {
        config == .parallel ? "C_total = C₁ + C₂ + C₃ + ..." : "1/C_total = 1/C₁ + 1/C₂ + 1/C₃ + ..."
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: formula,
                    variables: ["C_total = Total capacitance (F)"]
                )
                
                Form {
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
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Capacitance")
    }
}

#Preview {
    NavigationStack {
        CapacitanceView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
