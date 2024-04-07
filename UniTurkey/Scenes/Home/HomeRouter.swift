//
//  HomerRouter.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

final class HomeRouter: BaseRouter {
    override func create() -> UIViewController {
        let viewModel = HomeViewModel(router: self)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
}
