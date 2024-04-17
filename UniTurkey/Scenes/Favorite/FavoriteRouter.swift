//
//  FavoriteRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit

enum FavoriteRoute {
    case back
    case detail(UniversityRepresentation)
}

protocol FavoriteRouterProtocol {
    var navigationController: UINavigationController? { get }
    func navigate(to route: FavoriteRoute)
}

final class FavoriteRouter: FavoriteRouterProtocol {
    
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to route: FavoriteRoute) {
        guard let navigationController = navigationController else { return }
        switch route {
        case .back:
            navigationController.popViewController(animated: true)
        case .detail:
            print("Detail")
        }
    }
    
}
