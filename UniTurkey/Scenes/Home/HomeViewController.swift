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
        if errorView.isHidden{
            viewModel.checkFavorites(with: provinces)
        }
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
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews([loadingView,errorView,provincesTableView,paginationLoadingView,scrollTopButton])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.addBorder(width: 2, color: Constants.Color.borderColor)
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
        
        let indexSetProvinces = provinces.enumerated().compactMap {
            $0.element.isExpanded ? $0.offset : nil
        }
        
        provinces.forEach { $0.isExpanded = false }
        
        let indexPathsUniversities = provinces.enumerated().compactMap { $0.element.universities.enumerated().compactMap {
            $0.element.isExpanded ? IndexPath(row: $0.offset, section: $0.offset) : nil
            }
        }.flatMap { $0 }
        
        provinces.forEach { $0.universities.forEach { $0.isExpanded = false } }
        
        provincesTableView.reloadSections(IndexSet(indexSetProvinces), with: .fade)
        provincesTableView.reloadRows(at: indexPathsUniversities, with: .fade)
        
        
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
        provincesTableView.deselectRow(at: indexPath, animated: true)
        guard let province = provinces[safe: indexPath.section] else { return }
        if indexPath.row == 0 {
            guard !province.universities.isEmpty else {
                showAlert(title: "Warning! No University", message: "There is no university in this province.", actionTitle: "OK")
                return
            }
            province.toggleExpand()
            provincesTableView.reloadSections([indexPath.section], with: .fade)
        } else {
            guard let university = province.universities[safe: indexPath.row - 1] else { return }
            guard !university.details.isEmpty else {
                showAlert(title: "Warning! No Detail", message: "There is no detail for this university.", actionTitle: "OK")
                return
            }
            university.toggleExpand()
            provincesTableView.reloadRows(at: [indexPath], with: .fade)
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
        
        if scrollTopButton.isHidden && scrollView.contentOffset.y > 100  {
            scrollTopButton.isHidden = false
        } else if scrollView.contentOffset.y < 100 && !scrollTopButton.isHidden {
            scrollTopButton.isHidden = true
        }
        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        if scrollPercentage >= Constants.UI.infinityScrollPercentage && !provinces.isEmpty {
            
            let now = Date()
            if let lastRequestTime = lastScrollTime, now.timeIntervalSince(lastRequestTime) < Constants.UI.infinityScrollLateLimitSecond {
                return
            }
            
            viewModel.fetchProvinces()
            
            self.lastScrollTime = now
            
        }
        
        
    }
    
}

// MARK: - ViewModel Delegate

extension HomeViewController : HomeViewModelDelegate {
    
    func handleOutput(_ output: HomeViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .updateTitle(let title):
                navigationBarTitle.text = title
            case .updateProvinces(let provinces):
                self.provinces = provinces
                provincesTableView.isHidden = false
                provincesTableView.reloadData()
            case .updateLoading(let loading):
                if provinces.isEmpty {
                    loading ? startLoading() : stopLoading()
                } else {
                    loading ? paginationLoadingView.showLoading() : paginationLoadingView.hideLoading()
                }
            case .updateError(let error):
                showError(error)
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
    
    
    func didTapFavoriteButton(with university: UniversityRepresentation) {
        guard
            let university = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index],
            let provinceIndex = provinces.firstIndex(where: { $0.id == university.provinceId })
        else {
            return
        }
        university.toggleFavorite()
        provincesTableView.reloadRows(at: [IndexPath(row: university.index + 1, section: provinceIndex)], with: .fade)
        viewModel.didTapFavoriteButton(with: university)
    }
    
}


