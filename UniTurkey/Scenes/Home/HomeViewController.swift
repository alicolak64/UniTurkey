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
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        
        UniversityManager.shared.fetchUniversities(page: 1) { result in
            switch result {
            case .success(let universities):
                print(universities)
            case .failure(let error):
                print(error)
            }
        }
        
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

