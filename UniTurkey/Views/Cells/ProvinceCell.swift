//
//  ProvinceCell.swift
//  UniTurkey
//
//  Created by Ali Çolak on 12.04.2024.
//

import UIKit

protocol ProvinceCellProtocol: ReusableView {
    
}


final class ProvinceCell: UITableViewCell,ProvinceCellProtocol {
    
    // MARK: - Typealias
    typealias Model = UniversityProvinceRepresentation
    
    // MARK: - UI Components
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        provinceNameLabel.text = nil
        universityCountLabel.text = nil
    }
    
    // MARK: Layout
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        contentView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        contentView.addSubviews(expandIcon, provinceNameLabel, universityCountLabel)
    }
    
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
    
    // MARK: Configure
    func configure(with model: UniversityProvinceRepresentation) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provinceNameLabel.text = model.name
            self.updateExpansionFeature(isExpanded: model.isExpanded, isEmptyArray: model.universities.isEmpty)
            self.updateUniveristyCountLabel(universityCount: model.universities.count)
        }
        
    }
    
    private func updateExpansionFeature(isExpanded: Bool, isEmptyArray: Bool = false) {
        if isEmptyArray {
            expandIcon.image = nil
        } else {
            expandIcon.image = isExpanded ? Constants.Icon.minusIcon : Constants.Icon.plusIcon
        }
    }
    
    private func updateUniveristyCountLabel (universityCount: Int) {
        universityCountLabel.text = universityCount > 1 ? "\(universityCount) universities" : ( universityCount == 1 ? "\(universityCount) university" : Constants.Text.noUniversityText)
    }
    
}
