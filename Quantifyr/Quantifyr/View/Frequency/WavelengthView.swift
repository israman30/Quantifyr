//
//  WavelengthView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct WavelengthView: View {
    @State private var velocity = ""
    @State private var frequency = ""
    
    private var wavelength: Double? {
        guard let v = Double(velocity), let f = Double(frequency), f != 0 else { return nil }
        return v / f
    }
    
    private var steps: [String] {
        guard let _ = wavelength, let v = Double(velocity), let f = Double(frequency) else { return [] }
        return [
            "Given: v = \(v) m/s, f = \(f) Hz",
            "λ = v / f",
            "λ = \(v) / \(f)"
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormulaHelperView(
                    formula: "λ = v / f",
                    variables: ["λ = Wavelength (m)", "v = Wave velocity (m/s)", "f = Frequency (Hz)"]
                )
                
                Form {
                    Section("Input Values") {
                        TextField("Velocity (m/s)", text: $velocity)
                            .keyboardType(.decimalPad)
                        TextField("Frequency (Hz)", text: $frequency)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let wavelength {
                        Section("Result") {
                            Text(String(format: "%.4g m", wavelength))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Section {
                            StepByStepView(
                                steps: steps,
                                result: String(format: "λ = %.4g m", wavelength)
                            )
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Wavelength")
    }
}

#Preview {
    NavigationStack {
        WavelengthView()
    }
}
