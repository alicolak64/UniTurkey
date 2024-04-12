//
//  LoadingView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 10.04.2024.
//

import UIKit

// MARK: - Loading View Protocol
protocol LoadingViewProtocol {
    func showLoading()
    func hideLoading()
}

// MARK: - Loading State
enum LoadingState {
    case loading
    case loaded
}

// MARK: - Loading View
final class LoadingView: UIView, LoadingViewProtocol {
    
    // MARK: - UI
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Constants.Color.blackColor
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private var state: LoadingState = .loading {
        didSet {
            switch state {
            case .loading:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.startAnimating()
                }
            case .loaded:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    // MARK: - Loading View Protocol
    func showLoading() {
        state = .loading
    }
    
    func hideLoading() {
        state = .loaded
    }
    
}

