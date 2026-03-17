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
            VStack(alignment: .leading, spacing: 24) {
                // Formula
                VStack(alignment: .leading, spacing: 8) {
                    Text("Formula")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Text(formula)
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                // Optional content (e.g. picker for solve-for)
                optionalContent()
                
                // Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Input")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    inputContent()
                }
                
                // Calculate
                Button(action: onCalculate) {
                    Text("Calculate")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canCalculate)
                
                // Result
                if let result {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Result")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        ResultWithActionsView(result: result, fullText: fullResultText)
                    }
                    
                    // Steps (optional)
                    if let steps, !steps.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            StepByStepView(steps: steps, result: stepsResult ?? result)
                        }
                    }
                }
            }
            .padding()
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
