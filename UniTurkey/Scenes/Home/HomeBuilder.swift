//
//  HomeBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import UIKit

protocol HomeBuildable {
    // MARK: - Methods
    func build() -> UIViewController
}

final class HomeBuilder: HomeBuildable {
    
    // MARK: - Methods
    
    func build() -> UIViewController {
        let universityService = app.universityService
        let favoriteService = app.favoriteService
        let navigationController = app.navigationController
        let router = HomeRouter(navigationController: navigationController)
        let viewModel = HomeViewModel(router: router, universityService: universityService, favoriteService: favoriteService)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
    
}


