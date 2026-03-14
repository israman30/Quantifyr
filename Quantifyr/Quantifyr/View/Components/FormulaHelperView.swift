//
//  FormulaHelperView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

/// Displays a formula visually with large typography for the user to understand before entering values
struct FormulaHelperView: View {
    let formula: String
    let variables: [String]
    var largeTypography: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Formula")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(formula)
                .font(largeTypography ? .largeTitle : .title2)
                .fontWeight(.bold)
                .fontDesign(.monospaced)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            
            if !variables.isEmpty {
                HStack(spacing: 6) {
                    ForEach(variables, id: \.self) { variable in
                        Text(variable)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.quaternary)
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    FormulaHelperView(
        formula: "V = I × R",
        variables: ["V = Voltage", "I = Current", "R = Resistance"]
    )
    .padding()
}
