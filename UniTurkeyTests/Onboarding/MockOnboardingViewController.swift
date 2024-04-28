//
//  MockOnboardingViewController.swift
//  OnboardingViewModelTests
//
//  Created by Ali Çolak on 27.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockOnboardingViewController: OnboardingViewProtocol {
    
    var invokedPrepareOnboarding = false
    var invokedPrepareOnboardingCount = 0
    
    func prepareOnboarding() {
        invokedPrepareOnboarding = true
        invokedPrepareOnboardingCount += 1
    }
    
    var invokedPrepareUI = false
    var invokedPrepareUICount = 0
    
    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }
    
    var invokedPrepareConstraints = false
    var invokedPrepareConstraintsCount = 0
    
    func prepareConstraints() {
        invokedPrepareConstraints = true
        invokedPrepareConstraintsCount += 1
    }
    
    var invokedShowSkipButton = false
    var invokedShowSkipButtonCount = 0
    
    func showSkipButton() {
        invokedShowSkipButton = true
        invokedShowSkipButtonCount += 1
    }
    
    var invokedHideSkipButton = false
    var invokedHideSkipButtonCount = 0
    
    func hideSkipButton() {
        invokedHideSkipButton = true
        invokedHideSkipButtonCount += 1
    }
    
    
}
