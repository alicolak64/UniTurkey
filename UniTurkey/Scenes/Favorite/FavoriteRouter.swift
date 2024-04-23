//
//  FavoriteRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit

final class FavoriteRouter: FavoriteRouterProtocol {
    
    // MARK: - Dependency Properties
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func navigate(to route: FavoriteRoute) {
        guard let navigationController = navigationController else { return }
        switch route {
        case .back:
            navigationController.popViewController(animated: true)
        case .detail(let arguments):
            let detailViewController = DetailBuilder().build(with: arguments)
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
}
