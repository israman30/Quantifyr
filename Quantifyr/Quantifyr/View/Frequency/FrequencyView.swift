//
//  FrequencyView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct FrequencyView: View {
    var body: some View {
        List {
            ForEach(FormulaLibrary.frequency) { item in
                NavigationLink {
                    FormulaRegistry.destination(for: item.id)
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
            .navigationTitle("Frequency & Signal")
        }
    }
}


#Preview {
    NavigationStack {
        FrequencyView()
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
