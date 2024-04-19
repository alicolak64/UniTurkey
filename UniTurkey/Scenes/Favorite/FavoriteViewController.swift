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
    
    // MARK: - Properties
    
    private var universities = Array<UniversityRepresentation>()
    
    // MARK: - UI Components
    
    private lazy var navigationBarBackButton: UIBarButtonItem = {
        
        let backButton = UIButton(type: .custom)
        
        let backIcon = Constants.Icon.arrowBackIcon
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = Constants.Color.blackColor
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        return backButtonItem
        
    }()
    
    private lazy var navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleBoldFont
        label.textColor = Constants.Color.blackColor
        return label
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
    
    private lazy var universityTableView: UITableView = {
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
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.noFavoriteText
        label.font = Constants.Font.subtitleBoldFont
        label.textColor = Constants.Color.blackColor
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
        universityTableView.delegate = self
        universityTableView.dataSource = self
        
        // MARK: - Register Cells
        universityTableView.register(UniversityCell.self)
    }
    
    // MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = Constants.Color.backgroundColor
        configureNavigationBar()
        view.addSubviews(universityTableView, errorLabel,scrollTopButton)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.addBorder(width: 2, color: Constants.Color.borderColor)
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
        let indexSet = universities.enumerated().compactMap { $0.element.isExpanded ? $0.offset : nil }
        universities.forEach { $0.isExpanded = false }
        universityTableView.reloadRows(at: indexSet.map { IndexPath(row: $0, section: 0) }, with: .fade)
    }
    
    @objc private func scrollTopButtonTapped() {
        universityTableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            errorLabel.isHidden = false
            universityTableView.isHidden = true
        }
    }
    
    private func hideEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            errorLabel.isHidden = true
            universityTableView.isHidden = false
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let university = universities[safe: indexPath.row] else { return UITableViewCell() }
        let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: university)
        cell.delegate = self
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        universityTableView.deselectRow(at: indexPath, animated: true)
        guard let university = universities[safe: indexPath.row] else { return }
        guard !university.details.isEmpty else {
            showAlert(title: "Warning! No Detail", message: "There is no detail for this university.", actionTitle: "OK")
            return
        }
        university.toggleExpand()
        universityTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let university = universities[safe: indexPath.row] else { return 0 }
        return CGFloat(
            university.isExpanded && !university.details.isEmpty
            ? Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * university.details.count)
            : Constants.UI.nonExpandCellHeight
        )

    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollTopButton.isHidden && scrollView.contentOffset.y > 100  {
            scrollTopButton.isHidden = false
        } else if scrollView.contentOffset.y < 100 && !scrollTopButton.isHidden {
            scrollTopButton.isHidden = true
        }
        
    }
    
}

// MARK: - Favorite View Model Delegate

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func handleOutput(_ output: FavoriteViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            navigationBarTitle.text = title
            navigationBarTitle.adjustsFontSizeToFitWidth = true
        case .updateUniversity(let universities):
            self.universities = universities
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                universities.isEmpty ? showEmptyState() : hideEmptyState()
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
        guard
            let universityIndex = universities.firstIndex(where: { $0.provinceId == university.provinceId && $0.index == university.index }),
            let university = universities[safe: universityIndex]
        else {
            return
        }
        universities.remove(at: universityIndex)
        universityTableView.deleteRows(at: [IndexPath(row: universityIndex, section: 0)], with: .left)
        viewModel.removeFavorite(with: university)
    }
    
    
}
