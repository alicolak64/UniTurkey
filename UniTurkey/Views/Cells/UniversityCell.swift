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
    case didSelectFavorite(UniversityRepresentation)
    case didSelectWebsite(UniversityRepresentation)
    case didSelectPhone(UniversityRepresentation)
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
    
}

// MARK: - University Table View Cell
final class UniversityCell: UITableViewCell,UniversityCellProtocol {
    
    // MARK: - Typealias
    typealias Model = UniversityRepresentation
    
    // MARK: - Dependency Properties
    weak var delegate: UniversityCellDelegate?
    private var university: UniversityRepresentation?
        
    // MARK: - UI
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Color.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    
    private lazy var phoneInfo: InfoButton = {
        let button = InfoButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var faxInfo: InfoButton = {
        let button = InfoButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var websiteInfo: InfoButton = {
        let button = InfoButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addressInfo: InfoButton = {
        let button = InfoButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rectorInfo: InfoButton = {
        let button = InfoButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.frame = contentView.frame.inset(by: Constants.Layout.universityCellMargins)
        setupConstraints()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        
        titleView.addRoundedBorder(width: 1, color: UIColor.lightGray)
        titleView.addSubviews(expandIcon, universityNameLabel, favoriteButton)
        
        contentView.addSubviews(titleView, phoneInfo, faxInfo, websiteInfo, addressInfo, rectorInfo)
        
    }
    
    // MARK: Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 50),
            
            expandIcon.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            expandIcon.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            expandIcon.widthAnchor.constraint(equalToConstant: 20),
            expandIcon.heightAnchor.constraint(equalToConstant: 20),
            
            universityNameLabel.leadingAnchor.constraint(equalTo: expandIcon.trailingAnchor, constant: 10),
            universityNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            universityNameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            favoriteButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            
            phoneInfo.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            phoneInfo.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 30),
            phoneInfo.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            
            faxInfo.topAnchor.constraint(equalTo: phoneInfo.bottomAnchor, constant: 10),
            faxInfo.leadingAnchor.constraint(equalTo: phoneInfo.leadingAnchor),
            faxInfo.trailingAnchor.constraint(equalTo: phoneInfo.trailingAnchor),
            
            websiteInfo.topAnchor.constraint(equalTo: faxInfo.bottomAnchor, constant: 10),
            websiteInfo.leadingAnchor.constraint(equalTo: phoneInfo.leadingAnchor),
            websiteInfo.trailingAnchor.constraint(equalTo: phoneInfo.trailingAnchor),
            
            addressInfo.topAnchor.constraint(equalTo: websiteInfo.bottomAnchor, constant: 10),
            addressInfo.leadingAnchor.constraint(equalTo: phoneInfo.leadingAnchor),
            addressInfo.trailingAnchor.constraint(equalTo: phoneInfo.trailingAnchor),
            
            rectorInfo.topAnchor.constraint(equalTo: addressInfo.bottomAnchor, constant: 10),
            rectorInfo.leadingAnchor.constraint(equalTo: phoneInfo.leadingAnchor),
            rectorInfo.trailingAnchor.constraint(equalTo: phoneInfo.trailingAnchor),
            
        ])
    }
    
    // MARK: Configure
    func configure(with model: UniversityRepresentation) {
        university = model
        universityNameLabel.text = model.name
        
        if model.details.isEmpty {
            expandIcon.image = nil
            updateFavoriteFeature(isFavorite: model.isFavorite)
            hideDetails()
        } else {
            updateExpansionFeature(isExpanded: model.isExpanded)
            updateFavoriteFeature(isFavorite: model.isFavorite)
            
            if model.isExpanded {
                phoneInfo.configure(category: .phone, text: model.phone)
                faxInfo.configure(category: .fax, text: model.fax)
                websiteInfo.configure(category: .website, text: model.website)
                addressInfo.configure(category: .address, text: model.address)
                rectorInfo.configure(category: .rector, text: model.rector)
            }
        }
        
        
        
    }
    
    // MARK: Helpers
    private func updateExpansionFeature(isExpanded: Bool) {
        expandIcon.image = isExpanded ? Constants.Icon.minusIcon : Constants.Icon.plusIcon
        isExpanded ? showDetails() : hideDetails()
    }
    
    private func updateFavoriteFeature(isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Constants.Icon.heartFillIcon : Constants.Icon.heartIcon, for: .normal)
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
        notify(output: .didSelectFavorite(university))
    }
    
    @objc private func websiteButtonTapped() {
        print("Website Button Tapped")
        guard let university = university else { return }
        notify(output: .didSelectWebsite(university))
    }
    
    @objc private func phoneButtonTapped() {
        print("Phone Button Tapped")
        guard let university = university else { return }
        notify(output: .didSelectPhone(university))
    }
    
    
    // MARK: Delegate
    private func notify (output: UniversityCellOutput) {
        delegate?.handleOutput(output)
    }
    
    // MARK: Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        universityNameLabel.text = nil
        phoneInfo.prepareForReuse()
        faxInfo.prepareForReuse()
        websiteInfo.prepareForReuse()
        addressInfo.prepareForReuse()
        rectorInfo.prepareForReuse()
    }
    
    // MARK: Private Methods
    private func hideDetails() {
        phoneInfo.isHidden = true
        faxInfo.isHidden = true
        websiteInfo.isHidden = true
        addressInfo.isHidden = true
        rectorInfo.isHidden = true
    }
    
    private func showDetails() {
        phoneInfo.isHidden = false
        faxInfo.isHidden = false
        websiteInfo.isHidden = false
        addressInfo.isHidden = false
        rectorInfo.isHidden = false
    }
    
}
