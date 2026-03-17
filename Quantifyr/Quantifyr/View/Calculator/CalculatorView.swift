//
//  CalculatorView.swift
//  Quantifyr
//
//  TI-84 style scientific calculator using the MathParser engine.
//

import SwiftUI

struct CalculatorView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var expression = ""
    @State private var result = ""
    @State private var errorMessage: String?
    
    private var displayExpression: String {
        expression.isEmpty ? "0" : expression
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display
                VStack(alignment: .trailing, spacing: 8) {
                    Text(displayExpression)
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text(result)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundStyle(result.isEmpty ? .secondary : AppTheme.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if let err = errorMessage {
                        Text(err)
                            .font(AppTypography.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                
                // Button grid
                CalculatorButtonGrid { value in
                    handleInput(value)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Calculator")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("scientific_calculator")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("scientific_calculator") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("scientific_calculator") ? .yellow : .secondary)
                }
            }
        }
    }
    
    private func handleInput(_ value: String) {
        errorMessage = nil
        switch value {
        case "=":
            evaluate()
        case "C":
            expression = ""
            result = ""
        case "⌫":
            if !expression.isEmpty {
                expression.removeLast()
            }
        default:
            if ["sin", "cos", "tan", "log", "ln", "sqrt"].contains(value) {
                expression.append("\(value)(")
            } else {
                expression.append(value)
            }
        }
    }
    
    private func evaluate() {
        guard !expression.isEmpty else { return }
        if let res = ScientificCalculator.evaluate(expression: expression) {
            result = formatResult(res)
            historyManager.add(formulaName: "Calculator", result: "\(expression) = \(result)")
        } else {
            errorMessage = "Invalid expression"
        }
    }
    
    private func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        return String(format: "%.6g", value)
    }
}

// MARK: - Calculator Button Grid
private struct CalculatorButtonGrid: View {
    let onTap: (String) -> Void
    
    private let mainRows: [[String]] = [
        ["sin", "cos", "tan", "⌫"],
        ["log", "ln", "sqrt", "/"],
        ["7", "8", "9", "*"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "π", "^"],
        ["(", ")", "C", "="]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(Array(mainRows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        CalculatorButton(label: key, onTap: { onTap(key) })
                    }
                }
            }
        }
    }
}

// MARK: - Calculator Button
private struct CalculatorButton: View {
    let label: String
    let onTap: () -> Void
    
    private var isOperator: Bool {
        ["+", "-", "*", "/", "^", "="].contains(label)
    }
    
    private var isFunction: Bool {
        ["sin", "cos", "tan", "log", "ln", "sqrt"].contains(label)
    }
    
    private var isSpecial: Bool {
        label == "C" || label == "⌫"
    }
    
    private var backgroundColor: Color {
        if label == "=" { return AppTheme.accent }
        if isSpecial { return AppTheme.Category.electrical.opacity(0.3) }
        if isOperator { return AppTheme.accentLight }
        if isFunction { return AppTheme.Category.math.opacity(0.2) }
        return AppTheme.cardBackground
    }
    
    private var foregroundColor: Color {
        if label == "=" || isSpecial { return .primary }
        if isOperator || isFunction { return AppTheme.accent }
        return .primary
    }
    
    private var fontSize: CGFloat {
        if isFunction { return 14 }
        if label == "π" { return 22 }
        return 20
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: fontSize, weight: .medium, design: isFunction ? .default : .rounded))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CalculatorView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
