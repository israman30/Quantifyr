//
//  SpotlightRouter.swift
//  Quantifyr
//
//  Handles deep navigation when user opens app from Spotlight search.
//

import SwiftUI

@Observable
final class SpotlightRouter {
    var formulaIdToOpen: String?
    
    func openFormula(_ id: String) {
        formulaIdToOpen = id
    }
    
    func consumePendingNavigation() -> String? {
        defer { formulaIdToOpen = nil }
        return formulaIdToOpen
    }
}
