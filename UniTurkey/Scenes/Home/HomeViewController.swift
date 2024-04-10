//
//  HomeViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - HomeViewController
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
    
    private lazy var errorView : UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.bodyFont
        label.textColor = Constants.Color.blackColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,tableView,paginationLoadingView])
        errorView.addSubviews([errorLabel])
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
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            self.tableView.isHidden = false
            self.loadingView.hideLoading()
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorLabel.text = error.localizedDescription
            self.errorView.isHidden = false
        }
    }
    
}

// MARK: - Actions
extension HomeViewController {
    
    @objc private func favoriteButtonTapped() {
        print("Favorite Button Tapped")
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = provinces[indexPath.section].name
        } else {
            cell.textLabel?.text = provinces[indexPath.section].universities[indexPath.row - 1].name
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            provinces[indexPath.section].isExpanded.toggle()
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
            print(provinces[indexPath.section].universities[indexPath.row - 1].name)
        }
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
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

