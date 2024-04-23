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
        button.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
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
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup
    
    func prepareTableView() {
        // MARK: - TableView Dependencies
        provincesTableView.delegate = self
        provincesTableView.dataSource = self
        
        // MARK: - Register Cells
        provincesTableView.register(ProvinceCell.self)
        provincesTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    func prepareUI() {
        view.backgroundColor = Constants.Color.background
        view.addSubviews([loadingView,errorView,provincesTableView,paginationLoadingView,scrollTopButton])
    }
    
    func prepareNavigationBar(title: String) {
        navigationBarTitle.text = title
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = scaleDownNavigationBarItem
        navigationItem.rightBarButtonItem = favoriteNavigationBarItem
    }
    
    func prepareConstraints() {
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
        viewModel.didFavoriteButtonTapped()
    }
    
    @objc private func scaleDownButtonTapped() {
        viewModel.didScaleDownButtonTapped()
    }
    
    @objc private func scrollToTopButtonTapped() {
        viewModel.didScrollToTopButtonTapped()
    }
    
}


// MARK: - ViewModel Delegate

extension HomeViewController : HomeViewProtocol {
    
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provincesTableView.isHidden = true
            self.loadingView.showLoading()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.hideLoading()
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provincesTableView.isHidden = true
            self.errorView.showError(error: error)
        }
    }
    
    func startPaginationLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.paginationLoadingView.showLoading()
        }
    }
    
    func stopPaginationLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.paginationLoadingView.hideLoading()
        }
    }
    
    func showScrollToTopButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollTopButton.isHidden = false
        }
    }
    
    func hideScrollToTopButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollTopButton.isHidden = true
        }
    }
    
    func scrollToTop() {
        provincesTableView.setContentOffset(.zero, animated: true)
    }
    
    func showAlert(alertMessage: AlertMessage) {
        showAlert(title: alertMessage.title, message: alertMessage.message, actionTitle: "OK")
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provincesTableView.isHidden = false
            self.provincesTableView.reloadData()
        }
        
    }
    
    func reloadSections(at indexSet: IndexSet) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provincesTableView.reloadSections(indexSet, with: .automatic)
        }
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.provincesTableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    func shareDetail(text: String) {
        share(items: [text])
    }
    
}

// MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.isSection {
            guard let section = viewModel.cellForRow(at: indexPath.section) else { return UITableViewCell() }
            let cell: ProvinceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: section)
            return cell
        } else {
            guard let row = viewModel.cellForRow(at: indexPath) else { return UITableViewCell() }
            let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: row)
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(at: indexPath)
    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(contentOffset: scrollView.contentOffset, contentSize: scrollView.contentSize, bounds: scrollView.bounds)
    }
    
}

// MARK: - University Cell Delegate

extension HomeViewController: UniversityCellDelegate {
    
    
    func handleOutput(_ output: UniversityCellOutput) {
        switch output {
        case .didSelectFavorite(let university):
            viewModel.didSelectFavorite(university: university)
        case .didSelectDetail(let universityIndexPath, let detailIndexPath):
            viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: detailIndexPath)
        case .didShareDetail(let universityIndexPath, let detailIndexPath):
            viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: detailIndexPath)
        }
    }
    
}

// MARK: - Error View Delegate

extension HomeViewController: ErrorViewDelegate {
    
    func handleOutput(_ output: ErrorViewOutput) {
        switch output {
        case .retry:
            viewModel.didRertyButtonTapped()
        }
    }
    
}
