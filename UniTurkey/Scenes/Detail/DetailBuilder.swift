//
//  DetailBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import UIKit

protocol DetailBuildable {
    
    // MARK: - Methods
    
    func build(with university: UniversityRepresentation) -> UIViewController
}

final class DetailBuilder: DetailBuildable {
    
    // MARK: Methods
    
    func build(with university: UniversityRepresentation) -> UIViewController {
        let navigationController = app.navigationController
        let router = DetailRouter(navigationController: navigationController)
        let viewModel = DetailViewModel(router: router, university: university)
        let viewController = DetailViewController(viewModel: viewModel)
        return viewController
    }
    
}
