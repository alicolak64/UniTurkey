//
//  HomeContracts.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import UIKit

protocol HomeBuilderProtocol {
    // MARK: - Methods
    func build() -> UIViewController
}

struct DetailArguments {
    let name: String
    let url: String
}

enum HomeRoute {
    // MARK: Cases
    case detail(DetailArguments)
    case favorites
}

protocol HomeRouterProtocol {
    // MARK: Dependency Properties
    var navigationController: UINavigationController? { get }
    // MARK: Methods
    func navigate(to route: HomeRoute)
}

protocol HomeViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: HomeViewProtocol? { get set }
    
    // MARK: - Lifecycle Methods
    func viewDidLoad()
    func viewWillAppear()
    func viewDidLayoutSubviews()
    
    // MARK: - Actions
    
    func didFavoriteButtonTapped()
    func didScaleDownButtonTapped()
    func didScrollToTopButtonTapped()
    func didRertyButtonTapped()
    
    // MARK: - Table View Methods
    
    func numberOfSections() -> Int
    func numberOfRowsInSection(at section: Int) -> Int
    func cellForRow(at section: Int) -> ProvinceCellViewModel?
    func cellForRow(at indexPath: IndexPath) -> UniversityCellViewModel?
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func scrollViewDidScroll(contentOffset: CGPoint, contentSize: CGSize, bounds: CGRect)
    
    func didSelectFavorite(at indexPath: IndexPath)
    func didSelectFavorite(university: UniversityCellViewModel)
    func didSelectShare(universityIndexPath: IndexPath, detailIndexPath: IndexPath)
    func didSelectDetail(universityIndexPath: IndexPath, detailIndexPath: IndexPath)
    
}

protocol HomeViewProtocol: AnyObject {
    
    // MARK: - Lifecycle Methods
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidLayoutSubviews()
    
    // MARK: - UI Preparation
    
    func prepareTableView()
    func prepareNavigationBar(title: String)
    func prepareUI()
    func prepareConstraints()
    
    // MARK: - UI Update Methods
    
    func startLoading()
    func stopLoading()
    func startPaginationLoading()
    func stopPaginationLoading()
    func showError(_ error: Error)
    func showAlert(alertMessage: AlertMessage)
    func showScrollToTopButton()
    func hideScrollToTopButton()
    func scrollToTop()
    
    // MARK: Tableview Update Methods
    func reloadTableView()
    func reloadSections(at indexSet: IndexSet)
    func reloadRows(at indexPaths: [IndexPath])
    
    // MARK: - Actions
    
    func shareDetail(text: String)
    func callPhone(with: String)
    func sendEmail(with: String)
    func openMapAddress(with: String)
    func searchTextSafari(with: String)
    
}
