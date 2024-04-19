//
//  FavoriteViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import UIKit

enum FavoriteViewModelOutput {
    // MARK: - Cases
    case updateTitle(String)
    case updateEmptyState(Bool)
    
    case reloadTableView
    case reloadRows([IndexPath])
    case deleteRows([IndexPath])
    
    case updateScrollToTopVisible(Bool)
    case showAlert(AlertMessage)
}

protocol FavoriteViewModelDelegate: AnyObject, UniversityCellDelegate {
    // MARK: - Methods
    func handleOutput(_ output: FavoriteViewModelOutput)
}

protocol FavoriteViewModelProtocol {
    
    // MARK: - Dependency Properties
    
    var  delegate: FavoriteViewModelDelegate? { get set }
    
    // MARK: - Methods
    
    func fetchTitle()
    func fetchUniversities()
    func removeFavorite(with university: UniversityRepresentation)
    func toggleAllExpanded()

    func navigate(to route: FavoriteRoute)
    
}

final class FavoriteViewModel: NSObject {
    
    // MARK: - Dependency Properties
    
    weak var delegate: FavoriteViewModelDelegate?
    private let favoriteService: FavoriteService
    private let router: FavoriteRouterProtocol

    // MARK: - Data Source Properties
    
    private var universities = Array<UniversityRepresentation>()
    
    // MARK: - Init
    
    init(router: FavoriteRouterProtocol, favoriteService: FavoriteService) {
        self.favoriteService = favoriteService
        self.router = router
    }
    
}

// MARK: - Favorite ViewModel Delegate

extension FavoriteViewModel: FavoriteViewModelProtocol {
    
    // MARK: - Methods
    
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.favoritesTitle))
    }
    
    func fetchUniversities() {
        getFavorites()
        if universities.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.notify(.updateEmptyState(true))
            }
        } else {
            notify(.updateEmptyState(false))
            notify(.reloadTableView)
        }
    }

    func removeFavorite(with university: UniversityRepresentation) {
        
        guard
            let universityIndex = universities.firstIndex(where: { $0 == university}),
            let university = universities[safe: universityIndex]
        else {
            return
        }
        
        university.toggleFavorite()
        universities.remove(at: universityIndex)
        notify(.deleteRows([IndexPath(row: universityIndex, section: 0)]))
        
        favoriteService.removeFavorite(with: university)
        
        checkEmptyState()
        
    }
    
    func toggleAllExpanded() {
        let indexSet = universities.enumerated().compactMap { $0.element.isExpanded ? $0.offset : nil }
        universities.forEach { $0.isExpanded = false }
        notify(.reloadRows(indexSet.map { IndexPath(row: $0, section: 0) }))
    }
    
    func navigate(to route: FavoriteRoute) {
        router.navigate(to: route)
    }
    
    // MARK: - Helpers
    
    private func getFavorites() {
        universities = favoriteService.getFavorites()
    }
    
    private func checkEmptyState() {
        if universities.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.notify(.updateEmptyState(true))
            }
        }  else {
            notify(.updateEmptyState(false))
        }
    }
    
    private func toogleExpand(at indexPath: IndexPath) {
        guard let university = universities[safe: indexPath.row] else { return }
        guard !university.details.isEmpty else {
            notify(.showAlert(AlertMessage(title: Constants.Text.warningNoDetailTitle, message: Constants.Text.warningNoDetailMessage)))
            return
        }
        university.toggleExpand()
        notify(.reloadRows([indexPath]))
    }
    
    private func notify(_ output: FavoriteViewModelOutput) {
        delegate?.handleOutput(output)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoriteViewModel: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let university = universities[safe: indexPath.row] else { return UITableViewCell() }
        let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: university)
        cell.delegate = delegate
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toogleExpand(at: indexPath)
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
        
        if scrollView.contentOffset.y > 100 {
            notify(.updateScrollToTopVisible(true))
        } else {
            notify(.updateScrollToTopVisible(false))
        }
        
    }
    
}


