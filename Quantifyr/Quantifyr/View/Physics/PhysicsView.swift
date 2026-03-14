//
//  PhysicsView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct PhysicsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ForceView()
                } label: {
                    Label("Force (F = ma)", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                }
                
                NavigationLink {
                    KineticEnergyView()
                } label: {
                    Label("Kinetic Energy (½mv²)", systemImage: "bolt.fill")
                }
                
                NavigationLink {
                    MomentumView()
                } label: {
                    Label("Momentum (p = mv)", systemImage: "arrow.forward")
                }
            }
            .navigationTitle("Physics")
        }
    }
}

#Preview {
    PhysicsView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
}
