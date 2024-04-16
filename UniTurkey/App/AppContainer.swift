//
//  AppContainer.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

// MARK: - App Container Instance
let app = AppContainer()


// MARK: - App Container
final class AppContainer {
    
    // MARK: - Properties
    let router = AppRouter()
    let universityService = UniversityManager.shared
    let favoriteService = FavoriteManager.shared
    
}
