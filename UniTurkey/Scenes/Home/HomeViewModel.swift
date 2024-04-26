//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: HomeViewProtocol?
    private let universityService: UniversityService
    private let favoriteService: FavoriteService
    private let router: HomeRouterProtocol
    
    // MARK: - Properties
    
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    private var provinces = Array<Province>()
    private var favorites = Array<University>()
    private var lastScrollTime: Date?
    
    
    private var loading: Bool = false {
        didSet {
            if loading {
                provinces.isEmpty ? delegate?.startLoading() : delegate?.startPaginationLoading()
            } else {
                provinces.isEmpty ? delegate?.stopLoading() : delegate?.stopPaginationLoading()
            }
        }
    }
    private var error: Error? {
        didSet {
            if let error = error {
                delegate?.showError(error)
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
    
    // MARK: - Private Methods
    
    private func fetchProvinces() {
        guard currentPage < totalPages && !loading else {  return }
        loading = true
        universityService.fetchProvinces(page: currentPage + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                loading = false
                currentPage = response.currentPage
                totalPages = response.totalPages
                let newProvinces = response.provinces.map { Province(province: $0) }
                
                provinces.append(contentsOf: newProvinces)
                
                checkFavorites()
                
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.loading = false
                    self.error = error
                }
            }
        }
    }
    
    private func checkFavorites() {
        
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
        
        if error == nil && !provinces.isEmpty {
            delegate?.reloadTableView()
        }
        
    }
    
    private func getFavorites() {
        favorites = favoriteService.getFavorites()
    }
    
    private func navigate(to route: HomeRoute) {
        router.navigate(to: route)
    }
    
    private func numberOfProvinces() -> Int {
        provinces.count
    }
    
    private func numberOfUniversities(at index: Int) -> Int {
        guard let province = provinces[safe: index] else { return 0 }
        return province.universities.count
    }
    
    private func province(at index: Int) -> Province? {
        provinces[safe: index]
    }
    
    private func university(at indexPath: IndexPath) -> University? {
        guard let province = province(at: indexPath.section) else { return nil }
        guard let university = province.universities[safe: indexPath.row] else { return nil }
        return university
    }
    
    private func numberOfDetails(at indexPath: IndexPath) -> Int {
        guard let university = university(at: indexPath) else { return 0 }
        return university.isExpanded ? university.details.count : 0
    }
    
    private func isExpanded(at index: Int) -> Bool {
        guard let province = provinces[safe: index] else { return false }
        return province.isExpanded
    }
    
    private func isExpanded(at indexPath: IndexPath) -> Bool {
        guard let university = university(at: indexPath) else { return false }
        return university.isExpanded
    }
    
    private func toogleExpand(at index: Int) {
        guard let province = provinces[safe: index] else { return }
        
        guard !province.universities.isEmpty else {
            delegate?.showAlert(alertMessage: AlertMessage(title: Constants.Text.warningNoUniversityTitle, message: Constants.Text.warningNoUniversityMessage))
            return
        }
        
        province.toggleExpand()
        delegate?.reloadSections(at: IndexSet(integer: index))
    }
    
    private func toogleExpand(at indexPath: IndexPath) {
        guard let university = provinces[safe: indexPath.section]?.universities[safe: indexPath.row] else { return }
        
        guard !university.details.isEmpty else {
            delegate?.showAlert(alertMessage:AlertMessage(title: Constants.Text.warningNoDetailTitle, message: Constants.Text.warningNoDetailMessage))
            return
        }
        
        university.toggleExpand()
        delegate?.reloadRows(at: [indexPath.indexWithSection])
    }
    
    private func toggleFavorite(with university: University) {
        
        guard let university = provinces.first(where: { $0.id == university.provinceId })?.universities[safe: university.index] else { return }
        
        university.toggleFavorite()
        
        postFavorite(university)
        
    }
    
    private func toggleAllExpanded() {
        
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
        
        if !indexSetProvinces.isEmpty {
            delegate?.reloadSections(at: IndexSet(indexSetProvinces))
        }
        
        if !indexPathsUniversities.isEmpty {
            delegate?.reloadRows(at: indexPathsUniversities)
        }
        
    }
    
    private func postFavorite(_ university: University) {
        
        let favoriteUniversity = University(university: UniversityResponse(name: university.name, phone: university.phone, fax: university.fax, website: university.website, email: university.email, address: university.address, rector: university.rector), provinceId: university.provinceId, index: university.index)
        
        favoriteUniversity.toggleFavorite()
        
        favoriteService.isFavorite(favoriteUniversity)
        ? favoriteService.removeFavorite(with: favoriteUniversity)
        : favoriteService.addFavorite(favoriteUniversity)
        
        getFavorites()
        
    }
    
}

// MARK: - Home ViewModel Delegate

extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Lifecycle Methods
    
    func viewDidLoad() {
        fetchProvinces()
        delegate?.prepareTableView()
        delegate?.prepareNavigationBar(title: Constants.Text.homeTitle)
        delegate?.prepareUI()
    }
    
    func viewWillAppear() {
        checkFavorites()
    }
    
    func viewDidLayoutSubviews() {
        delegate?.prepareConstraints()
    }
    
    // MARK: - Actions
    
    func didFavoriteButtonTapped() {
        navigate(to: .favorites)
    }
    
    func didScaleDownButtonTapped() {
        toggleAllExpanded()
    }
    
    func didScrollToTopButtonTapped() {
        delegate?.scrollToTop()
    }
    
    func didSelectFavorite(at indexPath: IndexPath) {
        guard let university = university(at: indexPath.indexWithoutSection) else { return }
        toggleFavorite(with: university)
    }
    
    func didSelectFavorite(university: UniversityCellViewModel) {
        guard let university = self.university(at: university.indexPath.indexWithoutSection) else { return }
        toggleFavorite(with: university)
    }
    
    func didSelectShare(universityIndexPath: IndexPath, detailIndexPath: IndexPath) {
        guard let university = university(at: universityIndexPath.indexWithoutSection), let detail = university.details[safe: detailIndexPath.row] else { return }
        delegate?.shareDetail(text: detail.value)
    }
    
    func didSelectDetail(universityIndexPath: IndexPath, detailIndexPath: IndexPath) {
        guard let university = university(at: universityIndexPath.indexWithoutSection), let detail = university.details[safe: detailIndexPath.row] else { return }
        switch detail.category {
        case .phone:
            delegate?.callPhone(with: detail.value)
        case .fax:
            delegate?.showAlert(alertMessage: AlertMessage(title: "Fax", message: detail.value))
        case .website:
            navigate(to: .detail(DetailArguments(name: university.name, url: detail.value)))
        case .email:
            delegate?.sendEmail(with: detail.value)
        case .address:
            delegate?.openMapAddress(with: detail.value)
        case .rector:
            delegate?.searchTextSafari(with: detail.value)
        }
    }
    
    func didRertyButtonTapped() {
        // clear all data and fetch again
        currentPage = 0
        totalPages = 1
        loading = false
        error = nil
        provinces.removeAll()
        fetchProvinces()
    }
    
    func numberOfSections() -> Int {
        numberOfProvinces()
    }
    
    func numberOfRowsInSection(at section: Int) -> Int {
        isExpanded(at: section) ? numberOfUniversities(at: section) + 1 : 1
    }
    
    func cellForRow(at section: Int) -> ProvinceCellViewModel? {
        guard let province = province(at: section) else { return nil }
        return ProvinceCellViewModel(province: province)
    }
    
    func cellForRow(at indexPath: IndexPath) -> UniversityCellViewModel? {
        guard let university = university(at: indexPath.indexWithoutSection) else { return nil }
        return UniversityCellViewModel(university: university, indexPath: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        indexPath.isSection ? toogleExpand(at: indexPath.section) : toogleExpand(at: indexPath.indexWithoutSection)
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if indexPath.isSection {
            return CGFloat(Constants.UI.nonExpandCellHeight)
        } else {
            return isExpanded(at: indexPath.indexWithoutSection)
            ? CGFloat ( Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * numberOfDetails(at: indexPath.indexWithoutSection)))
            : CGFloat(Constants.UI.nonExpandCellHeight)
        }
    }
    
    func scrollViewDidScroll(contentOffset: CGPoint, contentSize: CGSize, bounds: CGRect) {
                
        contentOffset.y > 100 ? delegate?.showScrollToTopButton() : delegate?.hideScrollToTopButton()
        
        let contentHeight = contentSize.height
        let visibleHeight = bounds.height
        let scrollOffset = contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        if scrollPercentage >= Constants.UI.infinityScrollPercentage && numberOfProvinces() > 0 {
            
            let now = Date()
            if let lastRequestTime = lastScrollTime, now.timeIntervalSince(lastRequestTime) < Constants.UI.infinityScrollLateLimitSecond {
                return
            }
            
            fetchProvinces()
            
            lastScrollTime = now
            
        }
    }
    
}
