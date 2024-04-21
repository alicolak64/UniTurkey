//
//  OnboardingBuilder.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import UIKit

protocol OnboardingBuildable {
    // MARK: - Methods
    func build() -> UIViewController
}

final class OnboardingBuilder: OnboardingBuildable {
    
    // MARK: - Methods
    
    func build() -> UIViewController {
        let router = OnboardingRouter()
        let viewModel = OnboardingViewModel(router: router)
        let viewController = OnboardingViewController(viewModel: viewModel)
        return viewController
    }
    
}
