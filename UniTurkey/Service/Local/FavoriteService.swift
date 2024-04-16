//
//  LocalService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 15.04.2024.
//

import Foundation


// MARK: - Favorite Service
protocol FavoriteService {
    // MARK: - Methods
    func addFavorite(_ university: UniversityRepresentation)
    func removeFavorite(_ university: UniversityRepresentation)
    func getFavorites() -> [UniversityRepresentation]
    func isFavorite(_ university: UniversityRepresentation) -> Bool
}



