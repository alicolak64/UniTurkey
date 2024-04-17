//
//  InfoButton.swift
//  UniTurkey
//
//  Created by Ali Çolak on 16.04.2024.
//

import UIKit

protocol DetailCellProtocol: ReusableView {
    
}

final class DetailCell: UITableViewCell, DetailCellProtocol{
    // MARK: - Typealias
    typealias Model = UniversityRepresentation.Detail
    
    // MARK: - UI Components
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.Layout.detailCellMargins)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Layout
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        contentView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        contentView.addSubviews(icon, label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 18),
            
            label.centerYAnchor .constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    // MARK: - Configure
    func configure(with model: Model) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setIcon(with: model.category)
            self.adjustFontSize(for: model.value)

            self.label.text = model.value
            self.icon.tintColor = Constants.Color.blackColor
        }
    }
    
    // MARK: Helpers
    private func setIcon(with category: UniversityRepresentation.DetailCategory) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
        
            switch category {
            case .phone:
                self.icon.image = Constants.Icon.phoneIcon
            case .fax:
                self.icon.image = Constants.Icon.faxIcon
            case .website:
                self.icon.image = Constants.Icon.websiteIcon
            case .email:
                self.icon.image = Constants.Icon.emailIcon
            case .address:
                self.icon.image = Constants.Icon.addressIcon
            case .rector:
                self.icon.image = Constants.Icon.rectorIcon
            }
        }
    }
    
    private func adjustFontSize(for text: String) {
      let baseFontSize = Constants.Font.bodyFont.pointSize
      let targetWidth = contentView.frame.width - icon.frame.width - 16
      let estimatedSize = text.boundingRect(with: CGSize(width: targetWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], attributes: [.font: Constants.Font.bodyFont], context: nil).size

      if estimatedSize.height > contentView.frame.height {
        let scalingFactor = contentView.frame.height / estimatedSize.height
        let newFontSize = baseFontSize * scalingFactor
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.label.font = Constants.Font.bodyFont.withSize(newFontSize)
        }
      }
    }
    
}
