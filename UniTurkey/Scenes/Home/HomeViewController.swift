//
//  HomeViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Dependency Properties
    
    private let viewModel: HomeViewModel
    
    // MARK: - UI Components
    
    private lazy var navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleBoldFont
        label.textColor = Constants.Color.blackColor
        return label
    }()
    
    private lazy var favoriteNavigationBarItem: UIBarButtonItem = {
        
        let favoriteButton = UIButton(type: .custom)
        
        let heartIcon = Constants.Icon.heartIcon
        favoriteButton.setImage(heartIcon, for: .normal)
        favoriteButton.tintColor = Constants.Color.lightRedColor ?? .systemRed
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let favoriteButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        return favoriteButtonItem
        
    }()
    
    private lazy var scaleDownNavigationBarItem: UIBarButtonItem = {
        
        let scaleDownButton = UIButton(type: .custom)
        
        let scaleDownIcon = Constants.Icon.scaleDownIcon?.resizeImage(targetSize: CGSize(width: 35, height: 35))
        let tintedIcon = scaleDownIcon?.withRenderingMode(.alwaysTemplate)
        scaleDownButton.setImage(tintedIcon, for: .normal)
        scaleDownButton.tintColor = .systemBlue
        
        
        scaleDownButton.addTarget(self, action: #selector(scaleDownButtonTapped), for: .touchUpInside)
        
        let scaleDownButtonItem = UIBarButtonItem(customView: scaleDownButton)
        
        return scaleDownButtonItem
        
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paginationLoadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var provincesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Color.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var scrollTopButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.scroolTopIcon?.resizeImage(targetSize: CGSize(width: 50, height: 50)).withTintColor(.systemBlue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scrollTopButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Initializers
    
    init(viewModel: HomeViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkFavorites()
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
        viewModel.fetchProvinces()
        // tableview setup
        tableViewSetup()
    }
    
    private func tableViewSetup() {
        // MARK: - TableView Dependencies
        provincesTableView.delegate = viewModel
        provincesTableView.dataSource = viewModel
        
        // MARK: - Register Cells
        provincesTableView.register(ProvinceCell.self)
        provincesTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,provincesTableView,paginationLoadingView,scrollTopButton])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.addRoundedBorder(width: 2, color: Constants.Color.borderColor)
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = scaleDownNavigationBarItem
        navigationItem.rightBarButtonItem = favoriteNavigationBarItem
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            provincesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            provincesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            provincesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            provincesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollTopButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            paginationLoadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paginationLoadingView.bottomAnchor.constraint(equalTo: provincesTableView.bottomAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func favoriteButtonTapped() {
        viewModel.navigate(to: .favorites)
    }
    
    @objc private func scaleDownButtonTapped() {
        viewModel.toggleAllExpanded()
    }
    
    @objc private func scrollTopButtonTapped() {
        provincesTableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Helpers
    
    private func startLoading() {
        provincesTableView.isHidden = true
        loadingView.showLoading()
    }
    
    private func stopLoading() {
        loadingView.hideLoading()
    }
    
    private func showError(_ error: Error) {
        provincesTableView.isHidden = true
        errorView.showError(error: error)
    }
    
}


// MARK: - ViewModel Delegate

extension HomeViewController : HomeViewModelDelegate {
    
    func handleOutput(_ output: HomeViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .updateTitle(let title):
                self.navigationBarTitle.text = title
            case .updateLoading(let loading):
                if self.viewModel.isProvincesEmpty() {
                    loading ? self.startLoading() : self.stopLoading()
                } else {
                    loading ? self.paginationLoadingView.showLoading() : self.paginationLoadingView.hideLoading()
                }
            case .updateError(let error):
                self.showError(error)
            case .reloadTableView:
                self.provincesTableView.isHidden = false
                self.provincesTableView.reloadData()
            case .reloadSections(let section):
                self.provincesTableView.reloadSections(section, with: .automatic)
            case .reloadRows(let indexPaths):
                self.provincesTableView.reloadRows(at: indexPaths, with: .automatic)
            case .updateScrollToTopVisible(let visible):
                self.scrollTopButton.isHidden = !visible
            case .showAlert(let alertMessage):
                self.showAlert(title: alertMessage.title, message: alertMessage.message, actionTitle: "OK")
            }
        }
    }
}

// MARK: - University Cell Delegate

extension HomeViewController: UniversityCellDelegate {
    
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
        viewModel.toggleFavorite(with: university)
    }
    
}

// MARK: - Error View Delegate

extension HomeViewController: ErrorViewDelegate {
    
    func handleOutput(_ output: ErrorViewOutput) {
        switch output {
        case .retry:
            viewModel.didTryAgain()
        }
    }
    
}


