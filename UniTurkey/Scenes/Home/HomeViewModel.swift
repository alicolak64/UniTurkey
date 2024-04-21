//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

enum HomeViewModelOutput {
    // MARK: Cases
    case updateTitle(String)
    case updateLoading(Bool)
    case updateError(Error)
    
    case reloadTableView
    case reloadSections(IndexSet)
    case reloadRows([IndexPath])
    
    case showAlert(AlertMessage)
}

protocol HomeViewModelDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: HomeViewModelOutput)
}

protocol HomeViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: HomeViewModelDelegate? { get set }
    
    // MARK: - Main Methods
    
    func fetchTitle()
    func fetchProvinces()
    func didTryAgain()
    func checkFavorites()
    
    // MARK: - Data Source Methods
    
    func numberOfProvinces() -> Int
    func numberOfUniversities(at index: Int) -> Int
    func province(at index: Int) -> ProvinceRepresentation?
    func university(at indexPath: IndexPath) -> UniversityRepresentation?
    func isExpanded(at index: Int) -> Bool
    func isExpanded(at indexPath: IndexPath) -> Bool
    func toogleExpand(at index: Int)
    func toogleExpand(at indexPath: IndexPath)
    func numberOfDetails(at indexPath: IndexPath) -> Int
    func toggleFavorite(with university: UniversityRepresentation)
    func toggleAllExpanded()
    
    // MARK: - Navigation Methods
    
    func navigate(to route: HomeRoute)
    
}

final class HomeViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: HomeViewModelDelegate?
    private let universityService: UniversityService
    private let favoriteService: FavoriteService
    private let router: HomeRouterProtocol
    
    // MARK: - Properties
    
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    private var provinces = Array<ProvinceRepresentation>()
    private var favorites = Array<UniversityRepresentation>()
    
    private var loading: Bool = false {
        didSet {
            notify(.updateLoading(loading))
        }
    }
    private var error: Error? {
        didSet {
            if let error = error {
                notify(.updateError(error))
            }
        }
    }
    
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
        notify(.updateTitle(Constants.Text.homeTitle))
    }
    
    func fetchProvinces() {
        guard currentPage < totalPages && !loading else {  return }
        loading = true
        universityService.fetchProvinces(page: currentPage + 1) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.loading = false
                    self.currentPage = response.currentPage
                    self.totalPages = response.totalPages
                    let newProvinces = response.provinces.map { ProvinceRepresentation(province: $0)
                    }
                    // check if university is favorite
                    self.checkFavorites()
                    
                    self.provinces.append(contentsOf: newProvinces)
                    
                    self.notify(.reloadTableView)
                    
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        self.loading = false
                        self.error = error
                    }
                }
            }
        }
        
    }
    
    func checkFavorites() {
        getFavorites()
        provinces.forEach { province in
            province.universities.forEach { university in
                if favorites.contains( where: { $0 == university }) {
                    university.isFavorite = true
                } else {
                    university.isFavorite = false
                }
            }
        }
        
        if error == nil {
            notify(.reloadTableView)
        }
        
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
    
    func numberOfProvinces() -> Int {
        provinces.count
    }
    
    func numberOfUniversities(at index: Int) -> Int {
        guard let province = provinces[safe: index] else { return 0 }
        return province.universities.count
    }
    
    func province(at index: Int) -> ProvinceRepresentation? {
        provinces[safe: index]
    }
    
    func university(at indexPath: IndexPath) -> UniversityRepresentation? {
        guard let province = province(at: indexPath.section) else { return nil }
        return province.universities[safe: indexPath.row]
    }
    
    func numberOfDetails(at indexPath: IndexPath) -> Int {
        guard let university = university(at: indexPath) else { return 0 }
        return university.isExpanded ? university.details.count : 0
    }
    
    func isExpanded(at index: Int) -> Bool {
        guard let province = provinces[safe: index] else { return false }
        return province.isExpanded
    }
    
    func isExpanded(at indexPath: IndexPath) -> Bool {
        guard let university = university(at: indexPath) else { return false }
        return university.isExpanded
    }
    
    func toogleExpand(at index: Int) {
        guard let province = provinces[safe: index] else { return }
        
        guard !province.universities.isEmpty else {
            notify(.showAlert(AlertMessage(title: Constants.Text.warningNoUniversityTitle, message: Constants.Text.warningNoUniversityMessage)))
            return
        }
        
        province.toggleExpand()
        notify(.reloadSections(IndexSet(integer: index)))
    }
    
    func toogleExpand(at indexPath: IndexPath) {
        guard let university = provinces[safe: indexPath.section]?.universities[safe: indexPath.row] else { return }
        
        guard !university.details.isEmpty else {
            notify(.showAlert(AlertMessage(title: Constants.Text.warningNoDetailTitle, message: Constants.Text.warningNoDetailMessage)))
            return
        }
        
        university.toggleExpand()
        notify(.reloadRows([indexPath]))
    }
    
    func toggleFavorite(with university: UniversityRepresentation) {
        
        guard let university = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index] else { return }
        
        university.toggleFavorite()
        
        postFavorite(university)
        
    }
    
    func toggleAllExpanded() {

        let indexSetProvinces = provinces.enumerated().compactMap {
            $0.element.isExpanded ? $0.offset : nil
        }
        
        provinces.forEach { $0.isExpanded = false }
        
        let indexPathsUniversities = provinces.enumerated().compactMap { $0.element.universities.enumerated().compactMap {
            $0.element.isExpanded ? IndexPath(row: $0.offset, section: $0.offset) : nil
        }
        }.flatMap { $0 }
        
        provinces.forEach { $0.universities.forEach { $0.isExpanded = false } }
        
        // convert index array to IndexSet
        
        notify(.reloadSections(IndexSet(indexSetProvinces)))
        notify(.reloadRows(indexPathsUniversities))
    }
    
    func navigate(to route: HomeRoute) {
        router.navigate(to: route)
    }
    
    // MARK: - Helpers
    
    private func getFavorites() {
        favorites = favoriteService.getFavorites()
    }
    
    private func postFavorite(_ university: UniversityRepresentation) {
        
        let favoriteUniversity = UniversityRepresentation(university: UniversityResponse(name: university.name, phone: university.phone, fax: university.fax, website: university.website, email: university.email, address: university.address, rector: university.rector), provinceId: university.provinceId, index: university.index)
        
        favoriteUniversity.toggleFavorite()
        
        favoriteService.isFavorite(favoriteUniversity)
        ? favoriteService.removeFavorite(with: favoriteUniversity)
        : favoriteService.addFavorite(favoriteUniversity)
        
        getFavorites()
        
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleOutput(output)
    }
    
}

struct AlertMessage {
    let title: String
    let message: String
}


