//
//  MathView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/15/26.
//

import SwiftUI

struct MathView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        List {
            ForEach(FormulaLibrary.math) { item in
                Button {
                    coordinator.push(.formula(id: item.id))
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .frame(width: 32, alignment: .center)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.formula)
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Mathematics")
    }
}

#Preview {
    NavigationStack {
        MathView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
            .environment(SpotlightRouter())
            .environmentObject(Coordinator())
    }
}
