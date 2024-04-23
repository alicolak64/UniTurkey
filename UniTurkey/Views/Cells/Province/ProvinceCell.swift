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
    
    typealias Model = ProvinceCellViewModel
    
    // MARK: - UI Components
    
    private lazy var expandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.plus ?? UIImage()
        imageView.tintColor = Constants.Color.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var provinceNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitle
        label.textColor = Constants.Color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var universityCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.caption
        label.textColor = Constants.Color.black
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
        backgroundColor = Constants.Color.white
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
    
    func configure(with model: ProvinceCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provinceNameLabel.text = model.provinceName
            self.universityCountLabel.text = model.universityCountText
            switch model.expansionIconState {
            case .plus:
                self.expandIcon.image = Constants.Icon.plus
            case .minus:
                self.expandIcon.image = Constants.Icon.plus
            case .none:
                self.expandIcon.image = nil
            }
            
        }
    }
    
}
