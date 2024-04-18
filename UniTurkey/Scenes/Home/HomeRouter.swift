//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum HomeRoute {
    case detail(UniversityRepresentation)
    case favorites
}

protocol HomeRouterProtocol {
    var navigationController: UINavigationController? { get }
    func navigate(to route: HomeRoute)
}

final class HomeRouter: HomeRouterProtocol {
    
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func navigate(to route: HomeRoute) {
        guard let navigationController = navigationController else { return }
        switch route {
        case .detail(let university):
            print(university)
            /*
             let detailViewController = UniversityDetailBuilder().build(with: .init(university: university))
             navigationController.pushViewController(detailViewController, animated: true)
             */
        case .favorites:
            let favoriteViewController = FavoriteBuilder().build()
            navigationController.pushViewController(favoriteViewController, animated: true)
        }
        
    }
    
}
