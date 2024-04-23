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
    
    private lazy var trashNavigationBarItem: UIBarButtonItem = {
        
        let trashButton = UIButton(type: .custom)
        
        let trashIcon = Constants.Icon.trash
        trashButton.setImage(trashIcon, for: .normal)
        trashButton.tintColor = Constants.Color.darkRed
        
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        
        let trashButtonItem = UIBarButtonItem(customView: trashButton)
        
        return trashButtonItem
        
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
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup
    
    func prepareTableView() {
        // MARK: - TableView Dependencies
        universityTableView.delegate = self
        universityTableView.dataSource = self
        
        // MARK: - Register Cells
        universityTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    func prepareUI() {
        view.backgroundColor = Constants.Color.background
        view.addSubviews(universityTableView, errorLabel,scrollTopButton)
    }
    
    func prepareNavigationBar(title: String) {
        navigationBarTitle.text = title
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = navigationBarBackButton
        navigationItem.rightBarButtonItems = [scaleDownNavigationBarItem, trashNavigationBarItem]
    }
    
    func prepareConstraints() {
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
        viewModel.backButtonTapped()
    }
    
    @objc private func scaleDownButtonTapped() {
        viewModel.didScaleDownButtonTapped()
    }
    
    @objc private func scrollTopButtonTapped() {
        viewModel.didScrollToTopButtonTapped()
    }
    
    @objc private func trashButtonTapped() {
        viewModel.didTrashButtonTapped()
    }
}

extension FavoriteViewController: FavoriteViewProtocol {
    
    
    func showEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorLabel.isHidden = false
            self.universityTableView.isHidden = true
        }
    }
    
    func hideEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.errorLabel.isHidden = true
            self.universityTableView.isHidden = false
        }
    }
    
    
    func showAlert(alertMessage: AlertMessage) {
        showAlert(title: alertMessage.title, message: alertMessage.message, actionTitle: "OK")
    }
    
    func showActionSheet(alertMessage: AlertMessage, completion: (() -> Void)?) {
        showActionSheet(title: alertMessage.title, message: alertMessage.message) {
            completion?()
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
        universityTableView.setContentOffset(.zero, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.universityTableView.reloadData()
        }
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.universityTableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.universityTableView.deleteRows(at: indexPaths, with: .left)
        }
    }
    
    func shareDetail(text: String) {
        share(items: [text])
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel.cellForRow(at: indexPath) else { return UITableViewCell() }
        let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: row)
        cell.delegate = self
        return cell
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
        viewModel.scrollViewDidScroll(contentOffset: scrollView.contentOffset)
    }
    
}

// MARK: - University Cell Delegate

extension FavoriteViewController: UniversityCellDelegate{
    
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
