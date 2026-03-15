//
//  MetricPrefixView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct MetricPrefix: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let exponent: Int
    let multiplier: Double
}

struct MetricPrefixView: View {
    @State private var inputValue = ""
    @State private var fromPrefixIndex = 6  // base (10⁰)
    @State private var toPrefixIndex = 3    // kilo
    @State private var unitSymbol = ""     // e.g. "m", "F", "Ω"
    
    private static let prefixes: [MetricPrefix] = [
        MetricPrefix(name: "tera", symbol: "T", exponent: 12, multiplier: 1e12),
        MetricPrefix(name: "giga", symbol: "G", exponent: 9, multiplier: 1e9),
        MetricPrefix(name: "mega", symbol: "M", exponent: 6, multiplier: 1e6),
        MetricPrefix(name: "kilo", symbol: "k", exponent: 3, multiplier: 1e3),
        MetricPrefix(name: "base", symbol: "", exponent: 0, multiplier: 1),
        MetricPrefix(name: "milli", symbol: "m", exponent: -3, multiplier: 1e-3),
        MetricPrefix(name: "micro", symbol: "µ", exponent: -6, multiplier: 1e-6),
        MetricPrefix(name: "nano", symbol: "n", exponent: -9, multiplier: 1e-9),
        MetricPrefix(name: "pico", symbol: "p", exponent: -12, multiplier: 1e-12)
    ]
    
    private var result: String {
        guard let value = Double(inputValue) else { return "—" }
        let from = Self.prefixes[fromPrefixIndex]
        let to = Self.prefixes[toPrefixIndex]
        let baseValue = value * from.multiplier
        let converted = baseValue / to.multiplier
        let unit = unitSymbol.isEmpty ? "" : " \(to.symbol)\(unitSymbol)"
        return String(format: "%.6g\(unit)", converted)
    }
    
    private var formula: String {
        "10^\(Self.prefixes[fromPrefixIndex].exponent) → 10^\(Self.prefixes[toPrefixIndex].exponent)"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "Convert between metric prefixes",
                    variables: ["kilo 10³", "mega 10⁶", "giga 10⁹", "milli 10⁻³", "micro 10⁻⁶", "nano 10⁻⁹"]
                )
                
                Form {
                    Section("Prefix Reference") {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(Self.prefixes) { p in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(p.symbol.isEmpty ? "—" : p.symbol)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Text("10^\(p.exponent)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(6)
                                .background(.quaternary)
                                .cornerRadius(6)
                            }
                        }
                    }
                    
                    Section("Convert") {
                        TextField("Value", text: $inputValue)
                            .keyboardType(.decimalPad)
                            .validatedDecimalInput($inputValue)
                        
                        TextField("Unit (e.g. m, F, Ω)", text: $unitSymbol)
                        
                        Picker("From", selection: $fromPrefixIndex) {
                            ForEach(Array(Self.prefixes.enumerated()), id: \.offset) { i, p in
                                Text(p.symbol.isEmpty ? "base" : p.symbol).tag(i)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("To", selection: $toPrefixIndex) {
                            ForEach(Array(Self.prefixes.enumerated()), id: \.offset) { i, p in
                                Text(p.symbol.isEmpty ? "base" : p.symbol).tag(i)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Result") {
                        ResultWithActionsView(result: result)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Metric Prefix")
    }
}

#Preview {
    NavigationStack {
        MetricPrefixView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
