//
//  ElectricalView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

enum ElectricalTool: String, CaseIterable {
    case ohmsLaw = "Ohm's Law"
    case power = "Power"
    case resistor = "Resistor"
    case capacitance = "Capacitance"
}

struct ElectricalView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    OhmsLawView()
                } label: {
                    Label("Ohm's Law", systemImage: "bolt.fill")
                }
                
                NavigationLink {
                    PowerView()
                } label: {
                    Label("Power Calculation", systemImage: "gauge.with.dots.needle.67percent")
                }
                
                NavigationLink {
                    ResistorView()
                } label: {
                    Label("Resistor Calculator", systemImage: "rectangle.3.group")
                }
                
                NavigationLink {
                    CapacitanceView()
                } label: {
                    Label("Capacitance Calculator", systemImage: "capacitor.fill")
                }
            }
            .navigationTitle("Electrical")
        }
    }
}

#Preview {
    ElectricalView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
}
