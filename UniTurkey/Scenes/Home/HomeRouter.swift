//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

final class HomeRouter: HomeRouterProtocol {
    
    // MARK: - Dependency Properties
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func navigate(to route: HomeRoute) {
        guard let navigationController = navigationController else { return }
        switch route {
        case .detail(let arguments):
            let detailViewController = DetailBuilder().build(with: arguments)
            navigationController.pushViewController(detailViewController, animated: true)
        case .favorites:
            let favoriteViewController = FavoriteBuilder().build()
            navigationController.pushViewController(favoriteViewController, animated: true)
        }
    }
    
}
