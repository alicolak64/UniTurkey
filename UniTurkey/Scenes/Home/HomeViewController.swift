//
//  HomeViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getTitle()
    }
    
    override func prepare() {
        super.prepare()
        
        view.backgroundColor = .gray
        
        view.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
}

// MARK: - ViewModel Delegate
extension HomeViewController: HomeViewModelDelegate {
        
    func didUpdateTitle(title: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = title
        }
    }
    
}

