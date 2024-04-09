//
//  HomeViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    // MARK: - Dependency Properties
    private let viewModel: HomeViewModel
    private let router: HomeRouter
    
    // MARK: - Properties
    private var lastScrollTime: Date?
    
    // MARK: - Initializers
    init(viewModel: HomeViewModel, router: HomeRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .red
    }
    
}

// MARK: - ViewModel Delegate
extension HomeViewController : HomeViewModelDelegate {
    
    func handleOutput(_ output: HomeViewModelOutput) {
        
    }
    
    func navigate(to route: HomeRoute) {
        
    }
    
    
}

