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
    func navigate(to route: HomeRoute)
}

protocol HomeViewModelProtocol {
    // MARK: - Properties
    var  delegate: HomeViewModelDelegate? { get set }
    
    // MARK: - Methods
    func fetchTitle()
    func fetchUniversities()
    func selectUniversity(id: Int, at index: Int)
    func didTryAgain()
    
    func didTapFavoriteButton(with university: UniversityRepresentation)
}

final class HomeViewModel {
    
    // MARK: - Dependency Properties
    weak var delegate: HomeViewModelDelegate?
    private let universityService: UniversityService
    private let favoriteService: FavoriteService
    
    // MARK: - Data Source Properties
    private var title: String?
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    private var provinces = Array<UniversityProvinceResponse>()
    private var loading: Bool = false
    private var error: Error?
    
    private var favorites = Array<UniversityRepresentation>()
    
    // MARK: - Init
    init(service: UniversityService, favoriteService: FavoriteService) {
        self.universityService = service
        self.favoriteService = favoriteService
        getFavorites()
    }
    
}

// MARK: - Home ViewModel Delegate
extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Methods
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.homeTitleText))
    }
    
    func fetchUniversities() {
        guard currentPage < totalPages && !loading else {  return }
        notify(.updateLoading(true))
        universityService.fetchUniversities(page: currentPage + 1) { [weak self] result in
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
                    self.notify(.updateLoading(false))
                    self.notify(.updateError(error))
                }
            }
        }
        
    }
    
    func selectUniversity(id: Int, at index: Int) {
        guard let province = provinces.first(where: { $0.id == id }),
              let university = province.universities[safe: index] else {
            return
        }
        delegate?.navigate(to: .detail(university))
    }
    
    func didTryAgain() {
        // clear all data and fetch again
        currentPage = 0
        totalPages = 1
        loading = false
        error = nil
        provinces.removeAll()
        fetchUniversities()
    }
    
    func didTapFavoriteButton(with university: UniversityRepresentation) {
        if favoriteService.isFavorite(university) {
            favoriteService.removeFavorite(university)
        } else {
            favoriteService.addFavorite(university)
        }
        getFavorites()
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
