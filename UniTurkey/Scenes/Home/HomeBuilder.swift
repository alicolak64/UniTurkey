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
        let service = app.service
        let viewModel = HomeViewModel(service: service)
        let router = HomeRouter()
        let viewController = HomeViewController(viewModel: viewModel, router: router)
        guard let navigationController = viewController.navigationController else { return viewController }
        router.navigationController = navigationController
        return viewController
    }
    
}


