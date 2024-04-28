//
//  MockDetailRouter.swift
//  DetailViewModelTests
//
//  Created by Ali Çolak on 28.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockDetailRouter: DetailRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    
    func navigate(to route: UniTurkey.DetailRoute) {
        invokedNavigate = true
        invokedNavigateCount += 1
    }
    
}
