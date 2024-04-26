//
//  MockHomeRouter.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 23.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockHomeRouter: HomeRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: UniTurkey.HomeRoute, Void)?
    var invokedNavigateParametersList = [(route: UniTurkey.HomeRoute, Void)]()
    
    func navigate(to route: UniTurkey.HomeRoute) {
        invokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
        invokedNavigateParametersList.append((route, ()))
    }
    
    
}
