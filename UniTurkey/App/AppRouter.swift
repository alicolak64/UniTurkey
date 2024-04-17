//
//  AppRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

final class AppRouter {
    
    // MARK: - Properties
    let window: UIWindow
    
    // MARK: - Initializers
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    // MARK: - Start
    func start() {
        let homeViewController = HomeBuilder().build()
        let navigationController = app.navigationController
        navigationController.viewControllers = [homeViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

