//
//  FavoriteViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import Foundation

enum FavoriteViewModelOutput {
    // MARK: - Cases
    case updateTitle(String)
    case updateEmptyState(Bool)
    
    case reloadTableView
    case reloadRows([IndexPath])
    case deleteRows([IndexPath])
    
    case showAlert(AlertMessage)
}

protocol FavoriteViewModelDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: FavoriteViewModelOutput)
}

protocol FavoriteViewModelProtocol {
    
    // MARK: - Dependency Properties
    
    var  delegate: FavoriteViewModelDelegate? { get set }
    
    // MARK: - Main Methods
    
    func fetchTitle()
    func fetchUniversities()
    
    // MARK: - Data Source Methods
    
    func numberOfUniversities() -> Int
    func university(at index: Int) -> UniversityRepresentation?
    func numberOfDetails(at index: Int) -> Int
    func isExpanded(at index: Int) -> Bool
    func toogleExpand(at index: Int)
    func removeFavorite(with university: UniversityRepresentation)
    func toggleAllExpanded()
    
    // MARK: - Navigation Methods
    
    func navigate(to route: FavoriteRoute)
    
}

final class FavoriteViewModel {
    
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
    
    func numberOfUniversities() -> Int {
        universities.count
    }
    
    func university(at index: Int) -> UniversityRepresentation? {
        universities[safe: index]
    }
    
    func numberOfDetails(at index: Int) -> Int {
        universities[safe: index]?.details.count ?? 0
    }
    
    func isExpanded(at index: Int) -> Bool {
        universities[safe: index]?.isExpanded ?? false
    }
    
    func toogleExpand(at index: Int) {
        guard let university = universities[safe: index] else { return }
        guard !university.details.isEmpty else {
            notify(.showAlert(AlertMessage(title: Constants.Text.warningNoDetailTitle, message: Constants.Text.warningNoDetailMessage)))
            return
        }
        university.toggleExpand()
        notify(.reloadRows([IndexPath(row: index, section: 0)]))
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
    
    
    
    private func notify(_ output: FavoriteViewModelOutput) {
        delegate?.handleOutput(output)
    }
    
}



