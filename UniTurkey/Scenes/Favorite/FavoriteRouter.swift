//
//  FavoriteRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit

enum FavoriteRoute {
    // MARK: Cases
    case back
    case detail(UniversityRepresentation)
}

protocol FavoriteRouterProtocol {
    // MARK: Dependency Properties
    var navigationController: UINavigationController? { get }
    // MARK: Methods
    func navigate(to route: FavoriteRoute)
}

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
        case .detail(let university):
            let detailViewController = DetailBuilder().build(with: university)
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
}
