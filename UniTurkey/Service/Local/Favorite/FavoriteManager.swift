//
//  LocalManager.swift
//  UniTurkey
//
//  Created by Ali Çolak on 15.04.2024.
//

import Foundation

final class FavoriteManager: FavoriteService{
    
    // MARK: - Properties(Singleton)
    
    static let shared = FavoriteManager()
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Private Initializer
    
    private init() {}
    
    // MARK: - Methods
    
    func addFavorite(_ university: University) {
        userDefaults.set(object: university, forKey: university.name)
    }
    
    func removeFavorite(with university: University) {
        userDefaults.set(nil, forKey: university.name)
    }
    
    func removeAllFavorites(universities: [University]) {
        universities.forEach { removeFavorite(with: $0) }
    }
    
    func getFavorites() -> [University] {
        
        return userDefaults.dictionaryRepresentation().compactMap { key, value in
            guard let data = value as? Data,
                  let university = try? JSONDecoder().decode(University.self, from: data) else { return nil }
            return university
        }
        
    }
    
    func isFavorite(_ university: University) -> Bool {
        return userDefaults[university.name] != nil
    }
    
}
