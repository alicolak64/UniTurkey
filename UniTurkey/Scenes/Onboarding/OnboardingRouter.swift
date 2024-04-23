//
//  OnboardingRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import UIKit

final class OnboardingRouter: OnboardingRouterProtocol {
    
    // MARK: - Methods
    
    func navigate(to route: OnboardingRoute) {
        switch route {
        case .home:
            app.router.startHome()
        }
    }
    
}
