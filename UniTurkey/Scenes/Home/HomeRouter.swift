//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - Home Route Cases
enum HomeRoute {
    case detail(UniversityResponse)
    case favorites
}

// MARK: - Home Router Protocol
protocol HomeRouterProtocol {
    func navigate(to route: HomeRoute)
}

// MARK: - Home Router
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
