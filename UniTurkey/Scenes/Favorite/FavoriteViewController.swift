//
//  FavoriteViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    // MARK: Dependency Properties
    
    private let viewModel: FavoriteViewModel
            
    // MARK: - UI Components
    
    private lazy var navigationBarBackButton: UIBarButtonItem = {
        
        let backButton = UIButton(type: .custom)
        
        let backIcon = Constants.Icon.back
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = Constants.Color.black
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        return backButtonItem
        
    }()
    
    private lazy var navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleBold
        label.textColor = Constants.Color.black
        label.text = Constants.Text.favoritesTitle
        return label
    }()
    
    private lazy var scaleDownNavigationBarItem: UIBarButtonItem = {
        
        let scaleDownButton = UIButton(type: .custom)
        
        let scaleDownIcon = Constants.Icon.scaleDown
        scaleDownButton.setImage(scaleDownIcon, for: .normal)
        scaleDownButton.tintColor = Constants.Color.blue
        
        scaleDownButton.addTarget(self, action: #selector(scaleDownButtonTapped), for: .touchUpInside)
        
        let scaleDownButtonItem = UIBarButtonItem(customView: scaleDownButton)
        
        return scaleDownButtonItem
        
    }()
    
    private lazy var universityTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Color.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var scrollTopButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.scroolTop?.resizeImage(targetSize: CGSize(width: 50, height: 50)).withTintColor(.systemBlue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scrollTopButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.noFavorite
        label.font = Constants.Font.subtitleBold
        label.textColor = Constants.Color.black
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializers
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        initalSetup()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    // MARK: - Setup
    
    private func initalSetup() {
        // fetch title
        viewModel.fetchTitle()
        // fetch provinces
        viewModel.fetchUniversities()
        // tableview setup
        tableViewSetup()
    }
    
    private func tableViewSetup() {
        // MARK: - TableView Dependencies
        universityTableView.delegate = viewModel
        universityTableView.dataSource = viewModel
        
        // MARK: - Register Cells
        universityTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = Constants.Color.background
        configureNavigationBar()
        view.addSubviews(universityTableView, errorLabel,scrollTopButton)
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = navigationBarBackButton
        navigationItem.rightBarButtonItem = scaleDownNavigationBarItem
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            universityTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            universityTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            universityTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            universityTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            scrollTopButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        viewModel.navigate(to: .back)
    }
    
    @objc private func scaleDownButtonTapped() {
        viewModel.toggleAllExpanded()
    }
    
    @objc private func scrollTopButtonTapped() {
        universityTableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorLabel.isHidden = false
            self.universityTableView.isHidden = true
        }
    }
    
    private func hideEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorLabel.isHidden = true
            self.universityTableView.isHidden = false
        }
    }
    
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func handleOutput(_ output: FavoriteViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .updateTitle(let title):
                self.navigationBarTitle.text = title
            case .updateEmptyState(let isEmptyFavorite):
                isEmptyFavorite ? self.showEmptyState() : self.hideEmptyState()
            case .reloadTableView:
                self.universityTableView.reloadData()
            case .reloadRows(let indexPaths):
                self.universityTableView.reloadRows(at: indexPaths, with: .automatic)
            case .deleteRows(let indexPaths):
                self.universityTableView.deleteRows(at: indexPaths, with: .left)
            case .updateScrollToTopVisible(let visible):
                self.scrollTopButton.isHidden = !visible
            case .showAlert(let alertMessage):
                self.showAlert(title: alertMessage.title, message: alertMessage.message, actionTitle: "OK")
            }
        }
    }
    
}

// MARK: - University Cell Delegate

extension FavoriteViewController: UniversityCellDelegate{
    
    func handleOutput(_ output: UniversityCellOutput) {
        switch output {
        case .didSelectFavorite(let university):
            didTapFavoriteButton(with: university)
        case .didSelectDetail(let university, let detail):
            switch detail.category {
            case .phone:
                callPhone(with: detail.value)
            case .website:
                viewModel.navigate(to: .detail(university))
            case .email:
                sendEmail(with: detail.value)
            case .address:
                openMapAddress(with: detail.value)
            case .rector:
                searchTextSafari(with: detail.value)
            case .fax:
                showAlert(title: "Fax", message: detail.value, actionTitle: "OK")
            }
        case .didShareDetail(let text):
            share(items: [text])
        }
    }
    
    private func didTapFavoriteButton(with university: UniversityRepresentation) {
        viewModel.removeFavorite(with: university)
    }
    
    
}
