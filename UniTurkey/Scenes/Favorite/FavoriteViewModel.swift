//
//  FavoriteViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import Foundation

enum FavoriteViewModelOutput {
    case updateTitle(String)
    case updateUniversity([UniversityRepresentation])
}

protocol FavoriteViewModelDelegate: AnyObject {
    func handleOutput(_ output: FavoriteViewModelOutput)
}

protocol FavoriteViewModelProtocol {
    // MARK: - Properties
    var  delegate: FavoriteViewModelDelegate? { get set }
    
    // MARK: - Methods
    func fetchTitle()
    func fetchUniversities()
    func removeFavorite(with university: UniversityRepresentation)

    func navigate(to route: FavoriteRoute)
    
}

final class FavoriteViewModel {
    
    // MARK: - Dependency Properties
    weak var delegate: FavoriteViewModelDelegate?
    private let favoriteService: FavoriteService
    private let router: FavoriteRouterProtocol

    // MARK: - Data Source Properties
    private var title: String?
    private var universities = Array<UniversityRepresentation>()
    
    // MARK: - Init
    init(router: FavoriteRouterProtocol, favoriteService: FavoriteService) {
        self.favoriteService = favoriteService
        self.router = router
        updateFavorites()
    }
    
}

// MARK: - Favorite ViewModel Delegate
extension FavoriteViewModel: FavoriteViewModelProtocol {
    
    // MARK: - Methods
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.favoritesTitleText))
    }
    
    func fetchUniversities() {
        notify(.updateUniversity(universities))
    }

    func removeFavorite(with university: UniversityRepresentation) {
        
        university.toggleFavorite()
        favoriteService.removeFavorite(with: university)
        getFavorites()
        
    }
    
    func navigate(to route: FavoriteRoute) {
        router.navigate(to: route)
    }
    
    // MARK: - Helpers
    private func updateFavorites() {
        notify(.updateUniversity(favoriteService.getFavorites()))
    }
    
    private func getFavorites() {
        universities = favoriteService.getFavorites()
        if universities.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.notify(.updateUniversity(self.universities))
            }
        }
    }
    
    private func notify(_ output: FavoriteViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .updateUniversity(let universities):
            self.universities = universities
        }
        delegate?.handleOutput(output)
    }
}

