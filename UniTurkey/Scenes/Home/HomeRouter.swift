//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum HomeRoute {
    case detail(UniversityResponse)
    case favorites
}

protocol HomeRouterProtocol {
    func navigate(to route: HomeRoute)
}

final class HomeRouter: HomeRouterProtocol {
    
    var navigationController: UINavigationController?
    
    func navigate(to route: HomeRoute) {
        switch route {
        case .detail(let university):
            print(university)
            /*
             let detailViewController = UniversityDetailBuilder().build(with: .init(university: university))
             navigationController.pushViewController(detailViewController, animated: true)
             */
        case .favorites:
            print("Favorites")
        }
        
    }
    
}
