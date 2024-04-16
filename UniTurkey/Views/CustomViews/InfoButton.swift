//
//  InfoButton.swift
//  UniTurkey
//
//  Created by Ali Çolak on 16.04.2024.
//

import UIKit

// MARK: - Info Button Protocol
protocol InfoButtonProtocol {
    func configure(category: InfoButton.InfoCategory, text: String)
    func prepareForReuse()
}

// MARK: - Info Button
final class InfoButton: UIButton, InfoButtonProtocol {
    
    enum InfoCategory {
        case phone
        case fax
        case website
        case address
        case rector
    }
    
    // MARK: - UI
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(category: InfoCategory, text: String) {
        
        switch category {
        case .phone:
            icon.image =  Constants.Icon.phoneIcon
        case .website:
            icon.image =  Constants.Icon.websiteIcon
        case .fax:
            icon.image =  Constants.Icon.faxIcon
        case .address:
            icon.image =  Constants.Icon.addressIcon
        case .rector:
            icon.image =  Constants.Icon.rectorIcon
        }
        
        label.text = text
        icon.tintColor = Constants.Color.blackColor
        
        switch text.count {
        case 0...30:
            label.font = Constants.Font.subBodyFont
        case 31...50:
            label.font = Constants.Font.captionFont
        case 51...70:
            label.font = Constants.Font.subcaptionFont
        case 71...100:
            label.font = Constants.Font.littleFont
        case 101...:
            label.font = Constants.Font.miniFont
        default:
            label.font = Constants.Font.bodyFont
        }
        
    }
    
    // MARK: - Setup Constraints
    private func setupLayout() {
        addSubviews(icon, label)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 18),
            
            label.centerYAnchor .constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])

    }
    
    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        addRoundedBorder(width: 1, color: UIColor.lightGray)
    }
    
    func prepareForReuse() {
        label.text = nil
        icon.image = nil
    }
    
}

