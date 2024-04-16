//
//  HomeBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import UIKit

// MARK: - Home Buildable
protocol HomeBuildable {
    // MARK: - Methods
    func build() -> UIViewController
}

// MARK: - Home Builder
final class HomeBuilder: HomeBuildable {
    
    // MARK: - Methods
    func build() -> UIViewController {
        let universityService = app.universityService
        let favoriteService = app.favoriteService
        let viewModel = HomeViewModel(service: universityService, favoriteService: favoriteService)
        let router = HomeRouter()
        let viewController = HomeViewController(viewModel: viewModel, router: router)
        guard let navigationController = viewController.navigationController else { return viewController }
        router.navigationController = navigationController
        return viewController
    }
    
}


