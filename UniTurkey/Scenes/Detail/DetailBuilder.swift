//
//  DetailBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import UIKit

final class DetailBuilder: DetailBuilderProtocol {
    
    // MARK: Methods
    
    func build(with university: DetailArguments) -> UIViewController {
        let navigationController = app.navigationController
        let router = DetailRouter(navigationController: navigationController)
        let viewModel = DetailViewModel(router: router, university: university)
        let viewController = DetailViewController(viewModel: viewModel)
        return viewController
    }
    
}
