//
//  LocalService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 15.04.2024.
//

import Foundation

protocol FavoriteService {
    // MARK: - Methods
    func addFavorite(_ university: University)
    func removeFavorite(with university: University)
    func removeAllFavorites(universities: [University])
    func getFavorites() -> [University]
    func isFavorite(_ university: University) -> Bool
}



