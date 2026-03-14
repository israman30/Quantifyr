//
//  FormulaHelperView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

/// Displays a formula visually for the user to understand before entering values
struct FormulaHelperView: View {
    let formula: String
    let variables: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Formula")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(formula)
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            
            if !variables.isEmpty {
                HStack(spacing: 4) {
                    ForEach(variables, id: \.self) { variable in
                        Text(variable)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary)
                            .cornerRadius(4)
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
