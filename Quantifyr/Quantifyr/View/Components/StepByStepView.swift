//
//  StepByStepView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

/// Displays step-by-step solution for educational purposes
struct StepByStepView: View {
    let steps: [String]
    let result: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Step-by-Step Solution")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(step)
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                    }
                }
                
                if let result {
                    Divider()
                    Text(result)
                        .font(.headline)
                        .fontDesign(.monospaced)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
}

#Preview {
    StepByStepView(
        steps: [
            "Given: V = 12V, R = 4Ω",
            "I = V / R",
            "I = 12 / 4"
        ],
        result: "I = 3 A"
    )
    .padding()
}
