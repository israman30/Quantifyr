//
//  FavoritesManager.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import Foundation

@Observable
final class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let key = "quantifyr_favorites"
    
    var favoriteIds: Set<String> = []
    
    private init() {
        load()
    }
    
    func isFavorite(_ id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    func toggle(_ id: String) {
        if favoriteIds.contains(id) {
            favoriteIds.remove(id)
        } else {
            favoriteIds.insert(id)
        }
        save()
    }
    
    func add(_ id: String) {
        favoriteIds.insert(id)
        save()
    }
    
    func remove(_ id: String) {
        favoriteIds.remove(id)
        save()
    }
    
    private func load() {
        if let array = UserDefaults.standard.stringArray(forKey: key) {
            favoriteIds = Set(array)
        } else {
            favoriteIds = []
        }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(favoriteIds), forKey: key)
    }
}
