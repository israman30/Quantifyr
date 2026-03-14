//
//  ResultWithActionsView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/14/26.
//

import SwiftUI

/// Displays a calculation result with Copy and Share actions for students.
struct ResultWithActionsView: View {
    let result: String
    var fullText: String? = nil  // Optional: full text to share (e.g. steps + result)
    
    @State private var copied = false
    
    private var shareText: String {
        fullText ?? result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(result)
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Button {
                    UIPasteboard.general.string = result
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copied = false
                    }
                } label: {
                    Label(copied ? "Copied!" : "Copy", systemImage: copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
                .disabled(result.isEmpty)
                
                ShareLink(item: shareText, subject: Text("Calculation Result"), message: Text(shareText)) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
                .disabled(result.isEmpty)
            }
        }
    }
}

#Preview {
    ResultWithActionsView(result: "F = 24.5 N")
        .padding()
}
