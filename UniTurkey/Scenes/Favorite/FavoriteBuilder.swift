//
//  FavoriteBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit


final class FavoriteBuilder: FavoriteBuilderProtocol {
    
    // MARK: - Methods
    
    func build() -> UIViewController {
        let favoriteService = app.favoriteService
        let navigationController = app.navigationController
        let router = FavoriteRouter(navigationController: navigationController)
        let viewModel = FavoriteViewModel(router: router, favoriteService: favoriteService)
        let viewController = FavoriteViewController(viewModel: viewModel)
        return viewController
    }
    
}

