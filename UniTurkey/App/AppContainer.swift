//
//  AppContainer.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - App Container Instance
let app = AppContainer()


final class AppContainer {
    
    // MARK: - Properties
    
    let router = AppRouter()
    let navigationController = UINavigationController()
    let universityService = UniversityManager.shared
    let favoriteService = FavoriteManager.shared
    
}
