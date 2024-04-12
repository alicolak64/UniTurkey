//
//  ErrorView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 10.04.2024.
//

import UIKit

// MARK: - Error View Protocol
protocol ErrorViewProtocol {
    func showError(error: Error?)
    func hideError()
}

// MARK: - Error State
enum ErrorState {
    case error
    case noError
}

// MARK: - Error View Delegate
protocol ErrorViewDelegate: AnyObject {
    func didTapRetryButton()
}

// MARK: - Error View
final class ErrorView: UIView, ErrorViewProtocol {
    
    // MARK: - UI
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.errorIcon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var errorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.errorTitleText
        label.font = Constants.Font.subtitleBoldFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(Constants.Color.whiteColor, for: .normal)
        button.backgroundColor = Constants.Color.lightRedColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var state: ErrorState = .noError {
        didSet {
            switch state {
            case .error:
                isHidden = false
            case .noError:
                isHidden = true
            }
        }
    }
    
    // Dependency Properties
    weak var delegate: ErrorViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        addSubviews(errorImageView, errorTitleLabel, errorDescriptionLabel, retryButton)
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: topAnchor),
            errorImageView.widthAnchor.constraint(equalToConstant: 100),
            errorImageView.heightAnchor.constraint(equalToConstant: 100),
            
            errorTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorTitleLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 16),
            
            errorDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            errorDescriptionLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 8),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorDescriptionLabel.bottomAnchor, constant: 16),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
    // MARK: - Error View Protocol
    func showError(error: Error? = nil) {
        state = .error
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.errorDescriptionLabel.text = error.localizedDescription
            }
        }
    }
    
    func hideError() {
        state = .noError
    }
    
    // MARK: - Actions & Delegate
    @objc private func tryAgainButtonTapped() {
        hideError()
        delegate?.didTapRetryButton()
    }
    
}
