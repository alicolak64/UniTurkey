//
//  UniversityCell.swift
//  UniTurkey
//
//  Created by Ali Çolak on 13.04.2024.
//

import UIKit

// MARK: - University Table View Output
enum UniversityCellOutput {
    // MARK: - Cases
    case didSelectExpand(UniversityRepresentation)
    case didSelectFavorite(UniversityRepresentation)
    case didSelectWebsite(UniversityRepresentation)
    case didSelectPhone(String)
}

// MARK: - University Table View Delegate
protocol UniversityCellDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: UniversityCellOutput)
}

// MARK: - University Table View Cell Protocol
protocol UniversityCellProtocol: ReusableView {
    // MARK: - Properties
    var  delegate: UniversityCellDelegate? { get set }
    var  university: UniversityRepresentation? { get set }
    
    // MARK: - Methods
    func updateExpansionFeature(isExpanded: Bool)
}

// MARK: - University Table View Cell
final class UniversityCell: UITableViewCell,UniversityCellProtocol {
    
    // MARK: - Typealias
    typealias Model = UniversityRepresentation

    // MARK: - Dependency Properties
    weak var delegate: UniversityCellDelegate?
    var university: UniversityRepresentation?
    
    // MARK: - UI
    private lazy var expandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.plusIcon ?? UIImage()
        imageView.tintColor = Constants.Color.blackColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var universityNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyBoldFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.heartIcon, for: .normal)
        button.tintColor = Constants.Color.darkRedColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        
        contentView.addSubviews([expandIcon,universityNameLabel,favoriteButton])
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.Layout.universityCellMargins)
    }
    
    // MARK: Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                        
            expandIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            expandIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            expandIcon.widthAnchor.constraint(equalToConstant: 20),
            expandIcon.heightAnchor.constraint(equalToConstant: 20),
            
            universityNameLabel.leadingAnchor.constraint(equalTo: expandIcon.trailingAnchor, constant: 10),
            universityNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            universityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // MARK: Configure UI
    func configure(with model: UniversityRepresentation) {
        university = model
        universityNameLabel.text = model.name
    }
    
    // MARK: Update Expansion Feature
    func updateExpansionFeature(isExpanded: Bool) {
        expandIcon.image = isExpanded ? Constants.Icon.minusIcon : Constants.Icon.plusIcon
    }
    
    // MARK: Hit Test
    // Implemented to prevent the touch event from being triggered outside the cell
    // The reason for being outside cell is add UIEdgeInsets to contentView
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let insetRect = contentView.frame.inset(by: Constants.Layout.universityCellMargins)
      if !insetRect.contains(point) {
        return nil
      }
      return super.hitTest(point, with: event)
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        guard let university = university else { return }
        favoriteButton.currentImage == Constants.Icon.heartIcon 
        ? favoriteButton.setImage(Constants.Icon.heartFillIcon, for: .normal)
        : favoriteButton.setImage(Constants.Icon.heartIcon, for: .normal)
        notify(output: .didSelectFavorite(university))

    }
    
    // MARK: Delegate
    func notify (output: UniversityCellOutput) {
        delegate?.handleOutput(output)
    }
    
    // MARK: Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        universityNameLabel.text = nil
    }
    
}
    
