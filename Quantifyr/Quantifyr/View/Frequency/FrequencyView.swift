//
//  FrequencyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum FrequencyTool: String, CaseIterable {
    case wavelength = "Wavelength"
    case rcFilter = "RC Filter"
}

struct FrequencyView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    WavelengthView()
                } label: {
                    Label("Wavelength (λ = v/f)", systemImage: "waveform.path")
                }
                
                NavigationLink {
                    RCFilterView()
                } label: {
                    Label("RC Filter Frequency", systemImage: "waveform.circle")
                }
            }
            .navigationTitle("Frequency & Signal")
        }
    }
}

#Preview {
    FrequencyView()
}
