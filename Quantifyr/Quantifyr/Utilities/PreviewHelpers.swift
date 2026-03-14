//
//  PreviewHelpers.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/14/26.
//

import SwiftUI

/// Provides the shared environment objects required for previews.
/// Use this to wrap any view that (or whose children) use HistoryManager or FavoritesManager.
extension View {
    /// Adds HistoryManager and FavoritesManager to the environment for previews.
    func previewWithEnvironment() -> some View {
        self
            .environment(HistoryManager.shared)
            .environment(FavoritesManager.shared)
    }
}
