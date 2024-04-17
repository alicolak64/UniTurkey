//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

enum HomeViewModelOutput {
    case updateTitle(String)
    case updateProvinces([UniversityProvinceRepresentation])
    case updateLoading(Bool)
    case updateError(Error)
}

protocol HomeViewModelDelegate: AnyObject {
    func handleOutput(_ output: HomeViewModelOutput)
}

protocol HomeViewModelProtocol {
    // MARK: - Properties
    var  delegate: HomeViewModelDelegate? { get set }
    
    // MARK: - Methods
    func fetchTitle()
    func fetchProvinces()
    func didTryAgain()
    
    func checkFavorites(with provinces : [UniversityProvinceRepresentation])
    
    func navigate(to route: HomeRoute)
    
    func didTapFavoriteButton(with university: UniversityRepresentation)
}

final class HomeViewModel {
    
    // MARK: - Dependency Properties
    weak var delegate: HomeViewModelDelegate?
    private let universityService: UniversityService
    private let favoriteService: FavoriteService
    private let router: HomeRouterProtocol
    
    // MARK: - Data Source Properties
    private var title: String?
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    private var provinces = Array<UniversityProvinceResponse>()
    private var loading: Bool = false
    private var error: Error?
    
    private var favorites = Array<UniversityRepresentation>()
    
    // MARK: - Init
    init(router: HomeRouterProtocol, universityService: UniversityService, favoriteService: FavoriteService) {
        self.universityService = universityService
        self.favoriteService = favoriteService
        self.router = router
        getFavorites()
    }
    
}

// MARK: - Home ViewModel Delegate
extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Methods
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.homeTitleText))
    }
    
    func fetchProvinces() {
        guard currentPage < totalPages && !loading else {  return }
        notify(.updateLoading(true))
        universityService.fetchProvinces(page: currentPage + 1) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.notify(.updateLoading(false))
                    self.currentPage = response.currentPage
                    self.totalPages = response.totalPages
                    self.provinces.append(contentsOf: response.provinces)
                    let presentations = self.provinces.map { UniversityProvinceRepresentation(province: $0) }
                    // check if university is favorite
                    presentations.forEach { province in
                        province.universities.forEach { university in
                            if self.favorites.contains(where: { $0.provinceId == province.id && $0.name.apiCapitaledTrimmed == university.name  }) {
                                university.isFavorite = true
                            }
                        }
                    }
                    self.notify(.updateProvinces(presentations))
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        self.notify(.updateLoading(false))
                        self.notify(.updateError(error))
                    }
                }
            }
        }
        
    }
    
    func checkFavorites(with provinces: [UniversityProvinceRepresentation]) {
        getFavorites()
        provinces.forEach { province in
            province.universities.forEach { university in
                if !favorites.contains(where: { $0.provinceId == province.id && $0.name.apiCapitaledTrimmed == university.name }) {
                    university.isFavorite = false
                }
            }
        }
        notify(.updateProvinces(provinces))
    }
    
    func didTryAgain() {
        // clear all data and fetch again
        currentPage = 0
        totalPages = 1
        loading = false
        error = nil
        provinces.removeAll()
        fetchProvinces()
    }
    
    func didTapFavoriteButton(with university: UniversityRepresentation) {
        // create new university representation with favorite status
        guard let universityModel = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index] else { return }
        let favoriteUniversity = UniversityRepresentation(university: universityModel, provinceId: university.provinceId, index: university.index)
        favoriteUniversity.toggleFavorite()
        favoriteUniversity.isExpanded ? favoriteUniversity.toggleExpand() : nil
        if favoriteService.isFavorite(favoriteUniversity) {
            favoriteService.removeFavorite(with: favoriteUniversity)
        } else {
            favoriteService.addFavorite(favoriteUniversity)
        }
        getFavorites()
    }
    
    func navigate(to route: HomeRoute) {
        router.navigate(to: route)
    }
    
    // MARK: - Helpers
    private func getFavorites() {
        favorites = favoriteService.getFavorites()
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .updateProvinces(_):
            break
        case .updateLoading(let loading):
            self.loading = loading
        case .updateError(let error):
            self.error = error
        }
        delegate?.handleOutput(output)
    }
    
}
