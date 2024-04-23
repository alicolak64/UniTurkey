//
//  UniversityCell.swift
//  UniTurkey
//
//  Created by Ali Çolak on 13.04.2024.
//

import UIKit

enum UniversityCellOutput {
    // MARK: Cases
    case didSelectFavorite(UniversityCellViewModel)
    case didSelectDetail(IndexPath,IndexPath)
    case didShareDetail(IndexPath, IndexPath)
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
    
    typealias Model = UniversityCellViewModel
    
    // MARK: - Dependency Properties
    
    weak var delegate: UniversityCellDelegate?
    private var university: UniversityCellViewModel?
    
    // MARK: - UI Components
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var expandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.plus ?? UIImage()
        imageView.tintColor = Constants.Color.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var universityNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyBold
        label.textColor = Constants.Color.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.heart, for: .normal)
        button.tintColor = Constants.Color.darkRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButtonAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: Constants.Animation.Favorite.keyPath)
        animation.keyTimes = Constants.Animation.Favorite.keyTimes
        animation.duration = Constants.Animation.Favorite.duration
        return animation
    }()
    
    private lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Color.background
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
        expandIcon.image = Constants.Icon.plus
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
        backgroundColor = Constants.Color.white
        selectionStyle = .none
        
        titleView.addRoundedBorder(width: 1, color: Constants.Color.border)
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
    
    func configure(with model: UniversityCellViewModel) {
        
        university = model
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.universityNameLabel.text = model.universityName
            switch model.favoriteIconState {
            case .empty:
                favoriteButton.setImage(Constants.Icon.heart, for: .normal)
            case .filled:
                favoriteButton.setImage(Constants.Icon.heartFill, for: .normal)
            }
            switch model.expansionIconState {
            case .plus:
                self.expandIcon.image = Constants.Icon.plus
                showDetails()
                detailTableView.reloadData()
            case .minus:
                self.expandIcon.image = Constants.Icon.minus
                showDetails()
                detailTableView.reloadData()
            case .none:
                self.expandIcon.image = nil
                hideDetails()
            }
            
        }
        
    }
    
    // MARK: - Update UI
    
    private func updateFavoriteButtonImage(isFavorite: Bool) {
        favoriteButton.setImage(isFavorite ? Constants.Icon.heartFill : Constants.Icon.heart, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func favoriteButtonTapped() {
        guard let university = university else { return }
        self.university?.toggleFavorite()
        notify(output: .didSelectFavorite(university))
        addFavoriteButtonAnimation(isFavorite: university.isFavorite)
    }
    
    // MARK: Helpers
    
    private func hideDetails() {
        detailTableView.isHidden = true
    }
    
    private func showDetails() {
        detailTableView.isHidden = false
    }
    
    private func addFavoriteButtonAnimation(isFavorite: Bool) {
        favoriteButton.setImage(Constants.Icon.heartFill, for: .normal)
        favoriteButtonAnimation.values = Constants.Animation.Favorite.getValues(isFavorite: isFavorite)
        // finish animation run updateFavoriteFeature(isFavorite: !isFavorite)
        favoriteButton.layer.add(favoriteButtonAnimation, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.Favorite.duration) { [weak self] in
            self?.updateFavoriteButtonImage(isFavorite: !isFavorite)
        }
    }
    
    private func notify (output: UniversityCellOutput) {
        delegate?.handleOutput(output)
    }
    
}

// MARK: - TableView Delegate & DataSource

extension UniversityCell: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        university?.details.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let university = university, let detail = university.details[safe: indexPath.row] else { return UITableViewCell() }
        
        let cell: DetailCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: DetailCellViewModel(detail: detail, indexPath: indexPath))
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let university = university else { return }
        notify(output: .didSelectDetail(university.indexPath, indexPath))
    }
}

// MARK: - Detail Cell Delegate

extension UniversityCell: DetailCellDelegate {
    
    func handleOutput(_ output: DetailCellOutput) {
        switch output {
        case .didShareButton(let indexPath):
            guard let university = university else { return }
            notify(output: .didShareDetail(university.indexPath,indexPath))
        }
    }
    
}
