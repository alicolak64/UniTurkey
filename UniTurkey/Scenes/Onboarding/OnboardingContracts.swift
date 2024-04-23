//
//  OnboardingContracts.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import UIKit
import PaperOnboarding

protocol OnboardingBuilderProtocol {
    // MARK: - Methods
    func build() -> UIViewController
}

enum OnboardingRoute {
    // MARK: Cases
    case home
}

protocol OnboardingRouterProtocol {
    // MARK: Methods
    func navigate(to route: OnboardingRoute)
}

protocol OnboardingViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: OnboardingViewProtocol? { get set }
    
    // MARK: - Lifecycle Methods
    func viewDidLoad()
    func viewDidLayoutSubviews()
    
    // MARK: - Actions
    func didSkipButtonTapped()
    
    // MARK: - Onboarding Methods
    func onboardingWillTransitonToIndex(at index: Int)
    func numberOfPage() -> Int
    func pageForItem(at index: Int) -> OnboardingItemInfo
    
}

protocol OnboardingViewProtocol: AnyObject {
    // MARK: UI Methods
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func prepareOnboarding()
    func prepareUI()
    func prepareConstraints()
    
    // MARK: - Update UI Methods
    func showSkipButton()
    func hideSkipButton()
}
