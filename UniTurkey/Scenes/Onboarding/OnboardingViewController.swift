//
//  OnboardingViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import UIKit
import PaperOnboarding

final class OnboardingViewController: UIViewController {
    
    // MARK: - Dependency Properties
    
    private let viewModel: OnboardingViewModel
    
    // MARK: - UI Components
    
    private lazy var onboarding: PaperOnboarding = {
        let onboarding = PaperOnboarding()
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        return onboarding
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.Onboarding.skip, for: .normal)
        button.setTitleColor(Constants.Color.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Initializers
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup
    
    func prepareOnboarding() {
        onboarding.delegate = self
        onboarding.dataSource = self
    }
    
    // MARK: - Layout
    
    func prepareUI() {
        view.backgroundColor = Constants.Color.background
        view.addSubviews(onboarding,skipButton)
    }
    
    func prepareConstraints() {
        NSLayoutConstraint.activate([
            onboarding.topAnchor.constraint(equalTo: view.topAnchor),
            onboarding.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboarding.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboarding.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapSkipButton() {
        viewModel.didSkipButtonTapped()
    }
    
}

extension OnboardingViewController: PaperOnboardingDataSource,PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        viewModel.onboardingWillTransitonToIndex(at: index)
    }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        viewModel.pageForItem(at: index)
    }
    
    func onboardingItemsCount() -> Int {
        viewModel.numberOfPage()
    }
    
}

// MARK: - Onboarding View Protocol

extension OnboardingViewController: OnboardingViewProtocol {
    
    func showSkipButton() {
        DispatchQueue.main.async { [weak self] in
            self?.skipButton.isHidden = false
        }
    }
    
    func hideSkipButton() {
        DispatchQueue.main.async { [weak self] in
            self?.skipButton.isHidden = true
        }
    }
    
}
