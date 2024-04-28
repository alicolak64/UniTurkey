//
//  MockFavoriteManager.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockFavoriteManager: FavoriteService{
    
    // MARK: - Properties
    
    var favorites: [UniTurkey.University] = []
    
    // MARK: - Methods
    
    func addFavorite(_ university: UniTurkey.University) {
        if !isFavorite(university) {
            favorites.append(university)
        } else {
            favorites = favorites.filter{ $0 != university }
        }
    }
    
    func removeFavorite(with university: UniTurkey.University) {
        favorites = favorites.filter{ $0 != university }
    }
    
    func removeAllFavorites(universities: [UniTurkey.University]) {
        universities.forEach({ removeFavorite(with: $0) })
    }
    
    func getFavorites() -> [UniTurkey.University] {
        return favorites
    }
    
    func isFavorite(_ university: UniTurkey.University) -> Bool {
        return favorites.contains(university)
    }
    
    
}
