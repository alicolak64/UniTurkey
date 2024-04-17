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
    private let router: HomeRouter
    
    // MARK: - Properties
    private var lastScrollTime: Date?
    private var provinces = Array<UniversityProvinceRepresentation>()
    
    // MARK: - UI Components
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
    
    // MARK: - Layout
    private func configureUI() {
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,tableView,paginationLoadingView])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.addBorder(width: 2, color: Constants.Color.borderColor)
        navigationItem.titleView = navigationBarTitle
        navigationItem.rightBarButtonItem = navigationBarRightItem
    }
    
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
    
    @objc private func favoriteButtonTapped() {
        print("Favorite Button Tapped")
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
        provinces.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let province = provinces[safe: section] else { return 0 }
        return province.isExpanded ? province.universities.count + 1 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let province = provinces[safe: indexPath.section] else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell: ProvinceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: province)
            return cell
        } else {
            guard let university = province.universities[safe: indexPath.row - 1] else { return UITableViewCell() }
            let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: university)
            cell.delegate = self
            return cell
        }
        
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let province = provinces[safe: indexPath.section] else { return }
        if indexPath.row == 0 {
            guard !province.universities.isEmpty else {
                showAlert(title: "Warning! No University", message: "There is no university in this province.", actionTitle: "OK")
                return
            }
            province.toggleExpand()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadSections([indexPath.section], with: .fade)
            }
        } else {
            guard let university = province.universities[safe: indexPath.row - 1] else { return }
            guard !university.details.isEmpty else {
                showAlert(title: "Warning! No Detail", message: "There is no detail for this university.", actionTitle: "OK")
                return
            }
            university.toggleExpand()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            guard let province = provinces[safe: indexPath.section],
                  let university = province.universities[safe: indexPath.row - 1] 
            else {
                return 0
            }
            return CGFloat(
                university.isExpanded && !university.details.isEmpty ?
                           60 + (Constants.UI.detailCellHeight * university.details.count)
                           : 60
            )
        }
    }
    
    // MARK: - ScrollView Delegate
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
    
    func handleOutput(_ output: UniversityCellOutput) {
        switch output {
        case .didSelectFavorite(let university):
            didTapFavoriteButton(with: university)
        case .didSelectDetail(_, let detail):
            switch detail.category {
            case .phone:
                print("Phone: \(detail.value)")
            case .website:
                print("Website: \(detail.value)")
            case .email:
                print("Email: \(detail.value)")
            default:
                print("Detail: \(detail.value)")
            }
        }
    }
    
    
    func didTapFavoriteButton(with university: UniversityRepresentation) {
        guard
            let university = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index],
            let provinceIndex = provinces.firstIndex(where: { $0.id == university.provinceId })
        else {
            return
        }
        university.toggleFavorite()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath(row: university.index + 1, section: provinceIndex)], with: .fade)
        }
        
        viewModel.didTapFavoriteButton(with: university)
    }
    
}

