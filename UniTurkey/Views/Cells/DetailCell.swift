//
//  InfoButton.swift
//  UniTurkey
//
//  Created by Ali Çolak on 16.04.2024.
//

import UIKit

enum DetailCellOutput {
    // MARK: - Cases
    case didShareButton(String)
}

protocol DetailCellDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: DetailCellOutput)
}

protocol DetailCellProtocol: ReusableView {
    // MARK: - Dependency Properties
    var delegate: DetailCellDelegate? { get set }
}

final class DetailCell: UITableViewCell, DetailCellProtocol {
    
    // MARK: - Typealias
    
    typealias Model = UniversityRepresentation.Detail
    
    // MARK: - Dependency Properties
    
    weak var delegate: DetailCellDelegate?
    
    // MARK: - UI Components
    
    private lazy var detailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.shareIcon, for: .normal)
        button.tintColor = Constants.Color.blackColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
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
        detailIcon.image = nil
        detailLabel.text = nil
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        contentView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        contentView.addSubviews(detailIcon, detailLabel, shareButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            detailIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            detailIcon.heightAnchor.constraint(equalToConstant: 24),
            detailIcon.widthAnchor.constraint(equalToConstant: 18),
            
            detailLabel.centerYAnchor .constraint(equalTo: contentView.centerYAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: detailIcon.trailingAnchor, constant: 15),
            detailLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -8),
            
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            shareButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 24),
            shareButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // MARK: - Configure
    
    func configure(with model: Model) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setIcon(with: model.category)
            self.adjustFontSize(for: model.value)
            
            self.detailLabel.text = model.value
            self.detailIcon.tintColor = Constants.Color.blackColor
        }
    }
    
    // MARK: - Actions
    
    @objc private func shareButtonTapped() {
        guard let text = detailLabel.text else { return }
        notify(.didShareButton(text))
    }
    
    // MARK: Helpers
    
    private func setIcon(with category: UniversityRepresentation.DetailCategory) {
        switch category {
        case .phone:
            detailIcon.image = Constants.Icon.phoneIcon
        case .fax:
            detailIcon.image = Constants.Icon.faxIcon
        case .website:
            detailIcon.image = Constants.Icon.websiteIcon
        case .email:
            detailIcon.image = Constants.Icon.emailIcon
        case .address:
            detailIcon.image = Constants.Icon.addressIcon
        case .rector:
            detailIcon.image = Constants.Icon.rectorIcon
        }
    }
    
    private func adjustFontSize(for text: String) {
        if text.count < 35 {
            detailLabel.font = Constants.Font.bodyFont
            return
        }
        let baseFontSize = Constants.Font.bodyFont.pointSize
        let targetWidth = contentView.frame.width - detailIcon.frame.width - 16
        let estimatedSize = text.boundingRect(with: CGSize(width: targetWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], attributes: [.font: Constants.Font.bodyFont], context: nil).size
        
        if estimatedSize.height > contentView.frame.height {
            let scalingFactor = contentView.frame.height / estimatedSize.height
            let newFontSize = baseFontSize * scalingFactor
            detailLabel.font = Constants.Font.bodyFont.withSize(newFontSize)
        }
    }
    
    private func notify(_ output: DetailCellOutput) {
        delegate?.handleOutput(output)
    }
    
}
