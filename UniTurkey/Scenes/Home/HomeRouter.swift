//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - Home Route Cases
enum HomeRoute {
    // MARK: - Cases
    case detail(UniversityResponse)
    case favorites
}

// MARK: - Home Router Protocol
protocol HomeRouterProtocol {
    // MARK: - Methods
    func navigate(to route: HomeRoute)
}

// MARK: - Home Router
final class HomeRouter: HomeRouterProtocol {
    
    // MARK: - Properties
    var navigationController: UINavigationController?
    
    // MARK: - Methods
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
