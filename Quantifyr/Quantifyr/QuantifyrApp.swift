//
//  QuantifyrApp.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI
import CoreSpotlight

@main
struct QuantifyrApp: App {
    @State private var spotlightRouter = SpotlightRouter()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environment(HistoryManager.shared)
                .environment(FavoritesManager.shared)
                .environment(spotlightRouter)
                .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlightActivity)
                .onAppear {
                    SpotlightIndexer.indexAll()
                }
        }
    }
    
    private func handleSpotlightActivity(_ activity: NSUserActivity) {
        guard let id = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
        if let (type, formulaId) = SpotlightIndexer.parseIdentifier(id) {
            if type == "formula" {
                spotlightRouter.openFormula(formulaId)
            } else if type == "constant" {
                spotlightRouter.openFormula("constants")
            }
        }
    }
}
