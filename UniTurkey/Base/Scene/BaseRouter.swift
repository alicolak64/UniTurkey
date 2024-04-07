//
//  BaseRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

protocol BaseRouterProtocol {
}

class BaseRouter: Navigator, BaseRouterProtocol{
    
    override func create() -> UIViewController {
        let viewModel = BaseViewModel<BaseRouter >(router: self)
        let viewController = BaseViewController(viewModel: viewModel)
        return viewController
    }
    
    override func createWithNavigation() -> UIViewController {
        BaseNavigationController(rootViewController: create())
    }
}
