//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum HomeViewModelOutput {
    // MARK: Cases
    case updateTitle(String)
    case updateLoading(Bool)
    case updateError(Error)
    
    case reloadTableView
    case reloadSections(IndexSet)
    case reloadRows([IndexPath])
    
    case updateScrollToTopVisible(Bool)
    case showAlert(AlertMessage)
}

protocol HomeViewModelDelegate: AnyObject, UniversityCellDelegate {
    // MARK: - Methods
    func handleOutput(_ output: HomeViewModelOutput)
}

protocol HomeViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: HomeViewModelDelegate? { get set }
    
    // MARK: - Methods
    
    func fetchTitle()
    func fetchProvinces()
    func isProvincesEmpty() -> Bool
    func didTryAgain()
    func checkFavorites()
    
    func navigate(to route: HomeRoute)
    
    func toggleFavorite(with university: UniversityRepresentation)
    func toggleAllExpanded()
    
}

final class HomeViewModel: NSObject {
    
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
    private var lastScrollTime: Date?
    
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
        super.init()
        getFavorites()
    }
    
    
    
}

// MARK: - Home ViewModel Delegate

extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Methods
    
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.homeTitleText))
    }
    
    func isProvincesEmpty() -> Bool {
        return provinces.isEmpty
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
    
    func toggleFavorite(with university: UniversityRepresentation) {
        
        guard
            let university = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index],
            let provinceIndex = provinces.firstIndex(where: { $0.id == university.provinceId }),
            let universityIndex = provinces[provinceIndex].universities.firstIndex(where: { $0 == university })
        else {
            return
        }
        
        let indexPath = IndexPath(row: universityIndex + 1, section: provinceIndex)
        
        university.toggleFavorite()
        
        notify(.reloadRows([indexPath]))
        
        postFavorite(university)
        
    }
    
    func toggleAllExpanded() {
        // convert IndexSet
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
    
    private func toogleExpand(at index: Int) {
        guard let province = provinces[safe: index] else { return }
        
        guard !province.universities.isEmpty else {
            delegate?.handleOutput(.showAlert(AlertMessage(title: "Warning! No University", message: "There is no university in this province.")))
            return
        }
        
        province.toggleExpand()
        notify(.reloadSections(IndexSet(integer: index)))
    }
    
    private func toogleExpand(at indexPath: IndexPath) {
        guard let university = provinces[safe: indexPath.section]?.universities[safe: indexPath.row - 1] else { return }
        
        guard !university.details.isEmpty else {
            delegate?.handleOutput(.showAlert(AlertMessage(title: "Warning! No Detail", message: "There is no detail for this university.")))
            return
        }
        
        university.toggleExpand()
        notify(.reloadRows([indexPath]))
    }
    
    private func getFavorites() {
        favorites = favoriteService.getFavorites()
    }
    
    private func postFavorite(_ university: UniversityRepresentation) {
        
        let favoriteUniversity = UniversityRepresentation(university: UniversityResponse(name: university.name, phone: university.phone, fax: university.fax, website: university.website, email: university.email, address: university.address, rector: university.rector), provinceId: university.provinceId, index: university.index)
        
        favoriteUniversity.toggleFavorite()
        favoriteUniversity.isExpanded ? favoriteUniversity.toggleExpand() : nil
        
        favoriteService.isFavorite(favoriteUniversity) ?             favoriteService.removeFavorite(with: favoriteUniversity) :
                favoriteService.addFavorite(favoriteUniversity)
        
        getFavorites()
        
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleOutput(output)
    }
    
}

// MARK: - TableView Delegate

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        provinces.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let province = provinces[safe: section] else { return 0 }
        return province.isExpanded ? province.universities.count + 1 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let province = provinces[safe: indexPath.section] else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell: ProvinceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: province)
            return cell
        } else {
            guard let university = province.universities[safe: indexPath.row - 1] else { return UITableViewCell() }
            let cell: UniversityCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: university)
            cell.delegate = delegate
            return cell
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            toogleExpand(at: indexPath.section)
        } else {
            toogleExpand(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(Constants.UI.nonExpandCellHeight)
        } else {
            guard let province = provinces[safe: indexPath.section],
                  let university = province.universities[safe: indexPath.row - 1]
            else {
                return 0
            }
            return CGFloat(
                university.isExpanded && !university.details.isEmpty
                ? Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * university.details.count)
                : Constants.UI.nonExpandCellHeight
            )
        }
    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 100 {
            notify(.updateScrollToTopVisible(true))
        } else {
            notify(.updateScrollToTopVisible(false))
        }
        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        if scrollPercentage >= Constants.UI.infinityScrollPercentage && !provinces.isEmpty {
            
            let now = Date()
            if let lastRequestTime = lastScrollTime, now.timeIntervalSince(lastRequestTime) < Constants.UI.infinityScrollLateLimitSecond {
                return
            }
            
            fetchProvinces()
                        
            self.lastScrollTime = now
            
        }
        
        
    }
}

struct AlertMessage {
    let title: String
    let message: String
}
