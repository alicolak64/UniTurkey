//
//  MockHomeRouter.swift
//  HomeViewModelTests
//
//  Created by Ali Çolak on 23.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockHomeRouter: HomeRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (name: String, url: String)?
    var invokedNavigateParametersList = [(name: String, url: String)]()
    
    func navigate(to route: UniTurkey.HomeRoute) {
        invokedNavigate = true
        invokedNavigateCount += 1
        
        switch route {
        case .detail(let arguments):
            invokedNavigateParameters = (arguments.name, arguments.url)
            invokedNavigateParametersList.append((arguments.name, arguments.url))
        case .favorites:
            break
        }
        
    }
    
    
}
