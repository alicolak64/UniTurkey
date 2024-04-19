//
//  UniversityCell.swift
//  UniTurkey
//
//  Created by Ali Çolak on 13.04.2024.
//

import UIKit

enum UniversityCellOutput {
    // MARK: Cases
    case didSelectFavorite(UniversityRepresentation)
    case didSelectDetail(UniversityRepresentation,UniversityRepresentation.Detail)
    case didShareDetail(String)
}

protocol UniversityCellDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: UniversityCellOutput)
}

protocol UniversityCellProtocol: ReusableView {
    // MARK: - Dependency Properties
    var  delegate: UniversityCellDelegate? { get set }
}

final class UniversityCell: UITableViewCell,UniversityCellProtocol {
    
    // MARK: - Typealias
    
    typealias Model = UniversityRepresentation
    
    // MARK: - Dependency Properties
    
    weak var delegate: UniversityCellDelegate?
    private var university: UniversityRepresentation?
    
    // MARK: - UI Components
    
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
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        setupTableView()
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        university = nil
        universityNameLabel.text = nil
        expandIcon.image = Constants.Icon.plusIcon
        detailTableView.reloadData()
    }
    
    // Implemented to prevent the touch event from being triggered outside the cell
    // The reason for being outside cell is add UIEdgeInsets to contentView
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let insetRect = contentView.frame.inset(by: Constants.Layout.universityCellMargins)
        if !insetRect.contains(point) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(DetailCell.self)
    }
    
    // MARK: Layout
    
    private func setupUI() {
        backgroundColor = Constants.Color.whiteColor
        selectionStyle = .none
        
        titleView.addRoundedBorder(width: 1, color: Constants.Color.borderColor)
        titleView.addSubviews(expandIcon, universityNameLabel, favoriteButton)
        
        contentView.addSubviews(titleView, detailTableView)
        
    }
    
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
            
            detailTableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            detailTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    
    // MARK: Configure
    
    func configure(with model: UniversityRepresentation) {
        
        university = model
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            universityNameLabel.text = model.name
            updateFavoriteFeature(isFavorite: model.isFavorite)
            if model.details.isEmpty {
                expandIcon.image = nil
                hideDetails()
            } else {
                updateExpansionFeature(isExpanded: model.isExpanded)
            }
        }
        
        
        
    }
    
    // MARK: - Update UI
    
    private func updateExpansionFeature(isExpanded: Bool) {
        expandIcon.image = isExpanded ? Constants.Icon.minusIcon : Constants.Icon.plusIcon
        showDetails()
        detailTableView.reloadData()
    }
    
    private func updateFavoriteFeature(isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Constants.Icon.heartFillIcon : Constants.Icon.heartIcon, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func favoriteButtonTapped() {
        guard let university = university else { return }
        notify(output: .didSelectFavorite(university))
    }
    
    // MARK: Helpers
    
    private func hideDetails() {
        detailTableView.isHidden = true
    }
    
    private func showDetails() {
        detailTableView.isHidden = false
    }
    
    private func notify (output: UniversityCellOutput) {
        delegate?.handleOutput(output)
    }
    
}

// MARK: - TableView Delegate & DataSource

extension UniversityCell: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return university?.details.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let university = university, let detail = university.details[safe: indexPath.row] else { return UITableViewCell() }
        
        let cell: DetailCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: detail)
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let university = university, let detail = university.details[safe: indexPath.row] else { return }
        notify(output: .didSelectDetail(university,detail))
    }
}

// MARK: - Detail Cell Delegate

extension UniversityCell: DetailCellDelegate {
    
    func handleOutput(_ output: DetailCellOutput) {
        switch output {
        case .didShareButton(let text):
            notify(output: .didShareDetail(text))
        }
    }
    
}
