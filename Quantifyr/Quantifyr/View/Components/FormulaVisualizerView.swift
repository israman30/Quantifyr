//
//  FormulaVisualizerView.swift
//  Quantifyr
//
//  Interactive formula display with color-coded variables and tap-to-learn.
//

import SwiftUI

/// Variable metadata for formula visualization
struct FormulaVariable: Identifiable {
    let id: String
    let symbol: String
    let name: String
    let unit: String
    let color: Color
    let icon: String?
    
    var fullDescription: String { "\(symbol) = \(name) (\(unit))" }
    
    init(id: String, symbol: String, name: String, unit: String, color: Color, icon: String? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.unit = unit
        self.color = color
        self.icon = icon
    }
}

/// Interactive formula visualizer: color-coded variables, tap to learn.
struct FormulaVisualizerView: View {
    let formula: String
    let variables: [FormulaVariable]
    var title: String? = nil
    var largeTypography: Bool = true
    
    @State private var expandedVariable: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            // Formula with highlighted variables
            formulaDisplay
            
            // Variable chips - tap to expand
            variableChips
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var formulaDisplay: some View {
        HStack(spacing: 4) {
            ForEach(parseFormula(formula), id: \.id) { part in
                if let variable = variables.first(where: { $0.symbol == part.text }) {
                    Text(part.text)
                        .font(largeTypography ? .system(size: 32, weight: .bold) : .title2)
                        .fontDesign(.monospaced)
                        .foregroundStyle(variable.color)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(variable.color.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } else {
                    Text(part.text)
                        .font(largeTypography ? .system(size: 32, weight: .bold) : .title2)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var variableChips: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 8) {
            ForEach(variables) { variable in
                VariableChip(
                    variable: variable,
                    isExpanded: expandedVariable == variable.id
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        expandedVariable = expandedVariable == variable.id ? nil : variable.id
                    }
                }
            }
        }
    }
    
    /// Splits formula into parts (variables vs operators/symbols)
    private func parseFormula(_ formula: String) -> [(id: String, text: String)] {
        var parts: [(id: String, text: String)] = []
        let symbols = Set(variables.map(\.symbol))
        var i = formula.startIndex
        
        while i < formula.endIndex {
            var matched = false
            for sym in symbols.sorted(by: { $0.count > $1.count }) {
                if formula[i...].hasPrefix(sym) {
                    parts.append((id: "\(parts.count)-\(sym)", text: sym))
                    i = formula.index(i, offsetBy: sym.count)
                    matched = true
                    break
                }
            }
            if !matched {
                var chunk = ""
                while i < formula.endIndex {
                    let c = String(formula[i])
                    if symbols.contains(where: { formula[i...].hasPrefix($0) }) { break }
                    chunk += c
                    i = formula.index(after: i)
                }
                if !chunk.isEmpty {
                    parts.append((id: "\(parts.count)-\(chunk)", text: chunk))
                }
            }
        }
        return parts
    }
}

// MARK: - Variable Chip
private struct VariableChip: View {
    let variable: FormulaVariable
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    if let icon = variable.icon {
                        Image(systemName: icon)
                            .font(.system(size: 14))
                            .foregroundStyle(variable.color)
                    }
                    Text(variable.symbol)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(variable.color)
                    Text("= \(variable.name)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(variable.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(variable.color.opacity(0.4), lineWidth: isExpanded ? 2 : 1)
                )
                
                if isExpanded {
                    Text(variable.unit)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Presets for common formulas
extension FormulaVisualizerView {
    static func ohmsLaw() -> FormulaVisualizerView {
        FormulaVisualizerView(
            formula: "V = I × R",
            variables: [
                FormulaVariable(id: "v", symbol: "V", name: "Voltage", unit: "Volts (V)", color: .blue, icon: "bolt.fill"),
                FormulaVariable(id: "i", symbol: "I", name: "Current", unit: "Amps (A)", color: .green, icon: "arrow.right"),
                FormulaVariable(id: "r", symbol: "R", name: "Resistance", unit: "Ohms (Ω)", color: .orange, icon: "rectangle.3.group")
            ],
            title: "Ohm's Law"
        )
    }
    
    static func force() -> FormulaVisualizerView {
        FormulaVisualizerView(
            formula: "F = m × a",
            variables: [
                FormulaVariable(id: "f", symbol: "F", name: "Force", unit: "Newtons (N)", color: AppTheme.Category.physics, icon: "arrow.up.and.down.and.arrow.left.and.right"),
                FormulaVariable(id: "m", symbol: "m", name: "Mass", unit: "kg", color: AppTheme.Category.electrical, icon: nil),
                FormulaVariable(id: "a", symbol: "a", name: "Acceleration", unit: "m/s²", color: AppTheme.Category.frequency, icon: nil)
            ],
            title: "Newton's Second Law"
        )
    }
    
    static func power() -> FormulaVisualizerView {
        FormulaVisualizerView(
            formula: "P = V × I",
            variables: [
                FormulaVariable(id: "p", symbol: "P", name: "Power", unit: "Watts (W)", color: AppTheme.Category.electrical, icon: "gauge.with.dots.needle.67percent"),
                FormulaVariable(id: "v", symbol: "V", name: "Voltage", unit: "Volts (V)", color: .blue, icon: "bolt.fill"),
                FormulaVariable(id: "i", symbol: "I", name: "Current", unit: "Amps (A)", color: .green, icon: "arrow.right")
            ],
            title: "Power Law"
        )
    }
}

#Preview {
    VStack(spacing: 24) {
        FormulaVisualizerView.ohmsLaw()
        FormulaVisualizerView.force()
    }
    .padding()
}
