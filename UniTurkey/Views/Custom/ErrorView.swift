//
//  ErrorView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 10.04.2024.
//

import UIKit

protocol ErrorViewProtocol {
    // MARK: - Methods
    func showError(error: Error?)
    func hideError()
}

enum ErrorState {
    // MARK: Cases
    case error
    case noError
}

enum ErrorViewOutput {
    // MARK: Cases
    case retry
}

protocol ErrorViewDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: ErrorViewOutput)
}

final class ErrorView: UIView, ErrorViewProtocol {
    
    // MARK: Dependency Properties
    
    weak var delegate: ErrorViewDelegate?
    
    // MARK: - Properties
    
    private var state: ErrorState = .noError {
        didSet {
            switch state {
            case .error:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isHidden = false
                }
            case .noError:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isHidden = true
                }
            }
        }
    }
    
    // MARK: - UI Components
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.error
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var errorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.errorTitle
        label.font = Constants.Font.subtitleBold
        label.textColor = Constants.Color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.body
        label.textColor = Constants.Color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Text.retry, for: .normal)
        button.setTitleColor(Constants.Color.white, for: .normal)
        button.backgroundColor = Constants.Color.lightRed
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubviews(errorImageView, errorTitleLabel, errorDescriptionLabel, retryButton)
    }
    
    private func setupConstraints() {
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
    
    // MARK: - Actions
    
    @objc private func tryAgainButtonTapped() {
        hideError()
        notify(.retry)
    }
    
    // MARK: - Delegate Methods
    
    func showError(error: Error? = nil) {
        state = .error
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                errorDescriptionLabel.text = error.localizedDescription
            }
        }
    }
    
    func hideError() {
        state = .noError
    }
    
    // MARK: - Helpers
    
    private func notify(_ output: ErrorViewOutput) {
        delegate?.handleOutput(output)
    }
    
}
