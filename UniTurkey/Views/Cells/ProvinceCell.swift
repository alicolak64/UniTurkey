//
//  ProvinceCell.swift
//  UniTurkey
//
//  Created by Ali Çolak on 12.04.2024.
//

import UIKit

// MARK: - Province Table View Cell Protocol
protocol ProvinceCellProtocol: ReusableView {
    
}


// MARK: - Province Table View Cell
final class ProvinceCell: UITableViewCell,ProvinceCellProtocol {
    
    // MARK: - Typealias
    typealias Model = UniversityProvinceRepresentation
    
    // MARK: - UI
    private lazy var expandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.plusIcon ?? UIImage()
        imageView.tintColor = Constants.Color.blackColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var provinceNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var universityCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.captionFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.frame = contentView.frame.inset(by: Constants.Layout.provinceCellMargins)
        setupConstraints()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        contentView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        contentView.addSubviews(expandIcon, provinceNameLabel, universityCountLabel)
    }
    
    // MARK: Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            expandIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expandIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            expandIcon.widthAnchor.constraint(equalToConstant: 28),
            expandIcon.heightAnchor.constraint(equalToConstant: 28),
            
            provinceNameLabel.leadingAnchor.constraint(equalTo: expandIcon.trailingAnchor, constant: 8),
            provinceNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            universityCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            universityCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Configure UI
    func configure(with model: UniversityProvinceRepresentation) {
        provinceNameLabel.text = model.name
        updateExpansionFeature(isExpanded: model.isExpanded)
        if model.universities.count == 0 {
            universityCountLabel.text = Constants.Text.noUniversityText
            expandIcon.image = nil
        } else if model.universities.count == 1 {
            universityCountLabel.text = "\(model.universities.count) university"
        } else {
            universityCountLabel.text = "\(model.universities.count) universities"
        }
    }
    
    private func updateExpansionFeature(isExpanded: Bool) {
        expandIcon.image = isExpanded ? Constants.Icon.minusIcon : Constants.Icon.plusIcon
    }
    
    // MARK: Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        provinceNameLabel.text = nil
        universityCountLabel.text = nil
    }
    
    
}
