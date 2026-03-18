//
//  StepByStepView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

/// Displays step-by-step solution for educational purposes with Copy and Share for students.
struct StepByStepView: View {
    let steps: [String]
    let result: String?
    
    private var fullSolutionText: String {
        var lines = steps
        if let result { lines.append(result) }
        return lines.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text("Step-by-Step Solution")
                    .font(AppTypography.section)
                Spacer()
                if !fullSolutionText.isEmpty {
                    HStack(spacing: Spacing.s) {
                        Button {
                            UIPasteboard.general.string = fullSolutionText
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .font(.subheadline)
                        }
                        ShareLink(item: fullSolutionText, subject: Text("Step-by-Step Solution"), message: Text(fullSolutionText)) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: Spacing.s) {
                        Text("\(index + 1).")
                            .font(AppTypography.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(step)
                            .font(AppTypography.body)
                            .fontDesign(.monospaced)
                    }
                }
                
                if let result {
                    Divider()
                    Text(result)
                        .font(AppTypography.number)
                }
            }
            .padding(Spacing.m)
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
