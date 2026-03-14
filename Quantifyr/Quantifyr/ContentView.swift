//
//  ContentView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            OhmsLawView()
        }
    }
}

#Preview {
    ContentView()
}

struct OhmsLawView: View {
    
    @State private var voltage = ""
    @State private var resistance = ""
    @State private var current: Double?
    
    var body: some View {
        Form {
            
            Section("Input Values") {
                TextField("Voltage (V)", text: $voltage)
                TextField("Resistance (Ω)", text: $resistance)
            }
            
            Button("Calculate") {
                if let v = Double(voltage),
                   let r = Double(resistance) {
                    current = v / r
                }
            }
            
            if let current {
                Section("Result") {
                    Text("Current: \(current) A")
                }
            }
        }
    }
}
