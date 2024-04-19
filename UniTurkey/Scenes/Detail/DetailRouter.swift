//
//  DetailRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import UIKit

enum DetailRoute {
    // MARK: Cases
    case back
}

protocol DetailRouterProtocol {
    // MARK: Dependency Properties
    var navigationController: UINavigationController? { get }
    // MARK: Methods
    func navigate(to route: DetailRoute)
}

final class DetailRouter: DetailRouterProtocol {
    
    // MARK: - Dependency Properties
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func navigate(to route: DetailRoute) {
        guard let navigationController = navigationController else { return }
        switch route {
        case .back:
            navigationController.popViewController(animated: true)
        }
        
    }
    
}
