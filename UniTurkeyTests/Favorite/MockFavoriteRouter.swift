//
//  MockFavoriteRouter.swift
//  FavoriteViewModelTests
//
//  Created by Ali Çolak on 28.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockFavoriteRouter: FavoriteRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (name: String, url: String)?
    var invokedNavigateParametersList = [(name: String, url: String)]()
    
    func navigate(to route: UniTurkey.FavoriteRoute) {
        
        invokedNavigate = true
        invokedNavigateCount += 1
        
        switch route {
        case .detail(let arguments):
            invokedNavigateParameters = (arguments.name, arguments.url)
            invokedNavigateParametersList.append((arguments.name, arguments.url))
        case .back:
            break
        }
        
    }
    
}
