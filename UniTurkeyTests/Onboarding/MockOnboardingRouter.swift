//
//  MockOnboardingRouter.swift
//  OnboardingViewModelTests
//
//  Created by Ali Çolak on 27.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockOnboardingRouter: OnboardingRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    
    func navigate(to route: UniTurkey.OnboardingRoute) {
        invokedNavigate = true
        invokedNavigateCount += 1
    }
    
    
}
