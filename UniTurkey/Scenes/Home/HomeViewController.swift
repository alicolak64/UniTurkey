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
        label.font = Constants.Font.subtitleBold
        label.textColor = Constants.Color.black
        label.text = Constants.Text.homeTitle
        return label
    }()
    
    private lazy var favoriteNavigationBarItem: UIBarButtonItem = {
        
        let favoriteButton = UIButton(type: .custom)
        
        let heartIcon = Constants.Icon.heart
        favoriteButton.setImage(heartIcon, for: .normal)
        favoriteButton.tintColor = Constants.Color.lightRed ?? .systemRed
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let favoriteButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        return favoriteButtonItem
        
    }()
    
    private lazy var scaleDownNavigationBarItem: UIBarButtonItem = {
        
        let scaleDownButton = UIButton(type: .custom)
        
        let scaleDownIcon = Constants.Icon.scaleDown
        scaleDownButton.setImage(scaleDownIcon, for: .normal)
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
    
    // MARK: - Properties
    private var lastScrollTime: Date?
    
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
        provincesTableView.delegate = self
        provincesTableView.dataSource = self
        
        // MARK: - Register Cells
        provincesTableView.register(ProvinceCell.self)
        provincesTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = Constants.Color.background
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,provincesTableView,paginationLoadingView,scrollTopButton])
    }
    
    private func configureNavigationBar() {
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
    
    private func setScroolButtonVisible(_ isHidden: Bool) {
        scrollTopButton.isHidden = isHidden
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
                if self.viewModel.numberOfProvinces() == 0 {
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

// MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfProvinces()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isExpanded(at: section)
        ? tableView.numberOfRowsWithSection(numberOfRows: viewModel.numberOfUniversities(at: section))
        : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isSection(at: indexPath) {
            guard let province = viewModel.province(at: indexPath.section) else { return UITableViewCell() }
            let cell: ProvinceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: province)
            return cell
        } else {
            guard let university = viewModel.university(at: tableView.indexWithoutSection(from: indexPath)) else { return UITableViewCell() }
            let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: university)
            cell.delegate = self
            return cell
        }
        
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.isSection(at: indexPath)
        ? viewModel.toogleExpand(at: indexPath.section)
        : viewModel.toogleExpand(at: tableView.indexWithoutSection(from: indexPath))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isSection(at: indexPath) {
            return CGFloat(Constants.UI.nonExpandCellHeight)
        } else {
            return viewModel.isExpanded(at: tableView.indexWithoutSection(from: indexPath))
            ? CGFloat ( Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * viewModel.numberOfDetails(at: tableView.indexWithoutSection(from: indexPath))))
            : CGFloat(Constants.UI.nonExpandCellHeight)
        }
    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.y > 100 ? setScroolButtonVisible(false) : setScroolButtonVisible(true)
        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        if scrollPercentage >= Constants.UI.infinityScrollPercentage && viewModel.numberOfProvinces() > 0 {
            
            let now = Date()
            if let lastRequestTime = lastScrollTime, now.timeIntervalSince(lastRequestTime) < Constants.UI.infinityScrollLateLimitSecond {
                return
            }
            
            viewModel.fetchProvinces()
            
            lastScrollTime = now
            
        }
        
    }
}


