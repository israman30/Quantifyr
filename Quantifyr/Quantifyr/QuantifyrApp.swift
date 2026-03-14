//
//  QuantifyrApp.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

@main
struct QuantifyrApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(HistoryManager.shared)
                .environment(FavoritesManager.shared)
        }
    }
}
