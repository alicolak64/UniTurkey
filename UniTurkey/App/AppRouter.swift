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
        
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in // Wait 3 seconds for launch screen
            guard let self = self else { return }
            let homeViewController = HomeBuilder().build()
            let navigationController = app.navigationController
            navigationController.viewControllers = [homeViewController]
            window.rootViewController = navigationController
        }
        
    }
    
}

