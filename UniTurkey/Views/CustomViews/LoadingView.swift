//
//  LoadingView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 10.04.2024.
//

import UIKit

protocol LoadingViewProtocol {
    func showLoading()
    func hideLoading()
}

enum LoadingState {
    case loading
    case loaded
}

final class LoadingView: UIView, LoadingViewProtocol {
        
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Constants.Color.blackColor
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var state: LoadingState = .loading {
        didSet {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
            case .loaded:
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
                
    }
    
    func showLoading() {
        state = .loading
    }
    
    func hideLoading() {
        state = .loaded
    }
    
}

