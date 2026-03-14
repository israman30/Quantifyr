//
//  RootTabView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            UnitConverterView()
                .tabItem {
                    Label("Units", systemImage: "arrow.left.arrow.right")
                }
        }
    }
}

#Preview {
    RootTabView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
}
