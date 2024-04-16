//
//  LocalManager.swift
//  UniTurkey
//
//  Created by Ali Çolak on 15.04.2024.
//

import Foundation

// MARK: Favorite Manager
final class FavoriteManager: FavoriteService{
    
    // MARK: - Properties(Singleton)
    static let shared = FavoriteManager()
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Methods
    func addFavorite(_ university: UniversityRepresentation) {
        userDefaults.set(object: university, forKey: university.name)
    }
    
    func removeFavorite(_ university: UniversityRepresentation) {
        userDefaults.set(nil, forKey: university.name)
    }
    
    func getFavorites() -> [UniversityRepresentation] {
        
        return userDefaults.dictionaryRepresentation().compactMap { key, value in
            guard let data = value as? Data,
                  let university = try? JSONDecoder().decode(UniversityRepresentation.self, from: data) else { return nil }
            return university
        }
        
    }
    
    func isFavorite(_ university: UniversityRepresentation) -> Bool {
        return userDefaults[university.name] != nil
    }
    
}
