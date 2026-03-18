//
//  FormulaDetailView.swift
//  Quantifyr
//
//  Reusable formula detail layout: Title, Formula, Input, Calculate, Result, Steps.
//

import SwiftUI

/// Reusable layout for formula detail screens with consistent structure.
struct FormulaDetailView<InputContent: View, OptionalContent: View>: View {
    let title: String
    let formula: String
    let onCalculate: () -> Void
    let canCalculate: Bool
    let result: String?
    let steps: [String]?
    let stepsResult: String?  // Final line in Steps (e.g. "I = 3A")
    @ViewBuilder let inputContent: () -> InputContent
    @ViewBuilder let optionalContent: () -> OptionalContent
    
    init(
        title: String,
        formula: String,
        onCalculate: @escaping () -> Void,
        canCalculate: Bool,
        result: String?,
        steps: [String]? = nil,
        stepsResult: String? = nil,
        @ViewBuilder inputContent: @escaping () -> InputContent,
        @ViewBuilder optionalContent: @escaping () -> OptionalContent
    ) {
        self.title = title
        self.formula = formula
        self.onCalculate = onCalculate
        self.canCalculate = canCalculate
        self.result = result
        self.steps = steps
        self.stepsResult = stepsResult
        self.inputContent = inputContent
        self.optionalContent = optionalContent
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                // Formula
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Formula")
                        .font(AppTypography.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Text(formula)
                        .font(AppTypography.number)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.m)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                // Optional content (e.g. picker for solve-for)
                optionalContent()
                
                // Input
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Input")
                        .font(AppTypography.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    inputContent()
                }
                
                // Calculate
                Button(action: onCalculate) {
                    Text("Calculate")
                        .font(AppTypography.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canCalculate)
                
                // Result
                if let result {
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        Text("Result")
                            .font(AppTypography.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        ResultWithActionsView(result: result, fullText: fullResultText)
                    }
                    
                    // Steps (optional)
                    if let steps, !steps.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.s) {
                            Text("Steps")
                                .font(AppTypography.body)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            StepByStepView(steps: steps, result: stepsResult ?? result)
                        }
                    }
                }
            }
            .padding(Spacing.m)
        }
    }
    
    private var fullResultText: String {
        var lines = steps ?? []
        if let final = stepsResult ?? result { lines.append(final) }
        return lines.joined(separator: "\n")
    }
}

// MARK: - Convenience initializer without optional content
extension FormulaDetailView where OptionalContent == EmptyView {
    init(
        title: String,
        formula: String,
        onCalculate: @escaping () -> Void,
        canCalculate: Bool,
        result: String?,
        steps: [String]? = nil,
        stepsResult: String? = nil,
        @ViewBuilder inputContent: @escaping () -> InputContent
    ) {
        self.title = title
        self.formula = formula
        self.onCalculate = onCalculate
        self.canCalculate = canCalculate
        self.result = result
        self.steps = steps
        self.stepsResult = stepsResult
        self.inputContent = inputContent
        self.optionalContent = { EmptyView() }
    }
}

#Preview {
    NavigationStack {
        FormulaDetailView(
            title: "Ohm's Law",
            formula: "I = V / R",
            onCalculate: {},
            canCalculate: true,
            result: "3 Amps",
            steps: ["I = V / R", "I = 12 / 4"],
            stepsResult: "I = 3A",
            inputContent: {
                VStack(spacing: 12) {
                    TextField("Voltage (V)", text: .constant("12"))
                        .keyboardType(.decimalPad)
                    TextField("Resistance (Ω)", text: .constant("4"))
                        .keyboardType(.decimalPad)
                }
                .textFieldStyle(.roundedBorder)
            }, optionalContent: {
                Picker("Solve for", selection: .constant("Current (I)")) {
                    Text("Current (I)").tag("Current (I)")
                }
                .pickerStyle(.menu)
            }
        )
        .navigationTitle("Ohm's Law")
    }
}
