//
//  HomeViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - Home View Controller
final class HomeViewController: UIViewController {
    
    // MARK: - Dependency Properties
    private let viewModel: HomeViewModel
    private let router: HomeRouter
    
    // MARK: - Properties
    private var lastScrollTime: Date?
    private var provinces = Array<UniversityProvinceRepresentation>()
    
    // MARK: - UI
    private lazy var navigationBarTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.homeTitleText
        label.font = Constants.Font.subtitleBoldFont
        label.textColor = Constants.Color.blackColor
        return label
    }()
    
    private lazy var navigationBarRightItem: UIBarButtonItem = {
        
        let favouriteButton = UIButton(type: .custom)
        
        let heartIcon = Constants.Icon.heartIcon
        let heartIconSize = CGSize(width: 24, height: 24)
        favouriteButton.setImage(heartIcon, for: .normal)
        favouriteButton.tintColor = Constants.Color.lightRedColor ?? .systemRed
        
        favouriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let favouriteButtonItem = UIBarButtonItem(customView: favouriteButton)
        
        return favouriteButtonItem
        
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Color.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Initializers
    init(viewModel: HomeViewModel, router: HomeRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: - Register Cells
        tableView.register(ProvinceCell.self)
        tableView.register(UniversityCell.self)
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,tableView,paginationLoadingView])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.addBorder(width: 2, color: Constants.Color.borderColor ?? .systemGray4)
        navigationItem.titleView = navigationBarTitle
        navigationItem.rightBarButtonItem = navigationBarRightItem
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            paginationLoadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paginationLoadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -20)
            
        ])
    }
    
    // MARK: - Helpers
    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.loadingView.showLoading()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.hideLoading()
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorView.showError(error: error)
        }
    }
    
}

// MARK: - Actions
extension HomeViewController {
    
    // MARK: - Favorite Button Tapped
    @objc private func favoriteButtonTapped() {
        print("Favorite Button Tapped")
    }
    
}

// MARK: - Error View Delegate
extension HomeViewController: ErrorViewDelegate {
    
    // MARK: - Methods
    func handleOutput(_ output: ErrorViewOutput) {
        switch output {
        case .retry:
            viewModel.didTryAgain()
        }
    }
    
}


// MARK: - TableView Delegate & DataSource & ScrollView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        provinces.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if provinces[section].isExpanded {
            return provinces[section].universities.count + 1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell: ProvinceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: provinces[indexPath.section])
            return cell
        } else {
            let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: provinces[indexPath.section].universities[indexPath.row - 1])
            cell.delegate = self
            return cell
        }
        
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            guard !provinces[indexPath.section].universities.isEmpty else {
                return
            }
            provinces[indexPath.section].isExpanded.toggle()
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
            provinces[indexPath.section].universities[indexPath.row - 1].isExpanded.toggle()
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            if provinces[indexPath.section].universities[indexPath.row - 1].isExpanded {
                return 150
            } else {
                return 50
            }
        }
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // MARK: - Properties
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        // MARK: - Infinity Scroll
        if scrollPercentage >= Constants.UI.infinityScrollPercentage && !provinces.isEmpty {
            
            let now = Date()
            if let lastRequestTime = lastScrollTime, now.timeIntervalSince(lastRequestTime) < Constants.UI.infinityScrollLateLimitSecond {
                return
            }
            
            viewModel.fetchUniversities()
            
            self.lastScrollTime = now
            
        }
        
        
    }
    
}

// MARK: - ViewModel Delegate
extension HomeViewController : HomeViewModelDelegate {
    
    // MARK: Methods
    func handleOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.navigationBarTitle.text = title
            }
        case .updateProvinces(let provinces):
            self.provinces = provinces
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        case .updateLoading(let loading):
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.provinces.isEmpty {
                    loading ? self.startLoading() : self.stopLoading()
                } else {
                    loading ? self.paginationLoadingView.showLoading() : self.paginationLoadingView.hideLoading()
                }
            }
        case .updateError(let error):
            showError(error)
        }
    }
    
    func navigate(to route: HomeRoute) {
        
    }
    
}

// MARK: - University Cell Delegate
extension HomeViewController: UniversityCellDelegate {
    
    // MARK: Methods
    func handleOutput(_ output: UniversityCellOutput) {
        switch output {
        case .didSelectExpand(_):
            print("Expand Button Tapped")
        case .didSelectFavorite(let university):
            didTapFavoriteButton(with: university)
        case .didSelectWebsite(_):
            print("Website Button Tapped")
        case .didSelectPhone(_):
            print("Phone Button Tapped")
        }
    }
    
    
    func didTapFavoriteButton(with university: UniversityRepresentation) {
        print("Favorite Button Tapped")
    }
    
}

