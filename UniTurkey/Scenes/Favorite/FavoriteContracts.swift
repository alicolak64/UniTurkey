//
//  FavoriteContracts.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import UIKit

protocol FavoriteBuilderProtocol {
    // MARK: - Methods
    func build() -> UIViewController
}

enum FavoriteRoute {
    // MARK: Cases
    case back
    case detail(DetailArguments)
}

protocol FavoriteRouterProtocol {
    // MARK: Methods
    func navigate(to route: FavoriteRoute)
}

protocol FavoriteViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: FavoriteViewProtocol? { get set }
    
    // MARK: - Lifecycle Methods
    func viewDidLoad()
    func viewDidLayoutSubviews()
    
    // MARK: - Actions
    
    func backButtonTapped()
    func didScaleDownButtonTapped()
    func didScrollToTopButtonTapped()
    func didTrashButtonTapped()
    
    func numberOfRowsInSection(at section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> UniversityCellViewModel?
    func didSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func scrollViewDidScroll(contentOffset: CGPoint)
    
    func didSelectFavorite(university: UniversityCellViewModel)
    func didSelectShare(universityIndexPath: IndexPath, detailIndexPath: IndexPath)
    func didSelectDetail(universityIndexPath: IndexPath, detailIndexPath: IndexPath)
    
}

protocol FavoriteViewProtocol: AnyObject {
        
    // MARK: - UI Preparation
    
    func prepareTableView()
    func prepareNavigationBar(title: String)
    func prepareUI()
    func prepareConstraints()
    
    // MARK: - UI Update
    
    func showEmptyState()
    func hideEmptyState()
    func showAlert(alertMessage: AlertMessage)
    func showActionSheet(alertMessage: AlertMessage, completion: (() -> Void)?)
    func showScrollToTopButton()
    func hideScrollToTopButton()
    func scrollToTop()
    
    // MARK: - Table View 
    
    func reloadTableView()
    func reloadRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
    
    // MARK: - Actions
    
    func shareDetail(text: String)
    func callPhone(with: String)
    func sendEmail(with: String)
    func openMapAddress(with: String)
    func searchTextSafari(with: String)
    
}
