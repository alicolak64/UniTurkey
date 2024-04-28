//
//  FavoriteViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 17.04.2024.
//

import Foundation


final class FavoriteViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: FavoriteViewProtocol?
    private let favoriteService: FavoriteService
    private let router: FavoriteRouterProtocol
    
    // MARK: - Data Source Properties
    
    private var universities = Array<University>()
    
    // MARK: - Init
    
    init(router: FavoriteRouterProtocol, favoriteService: FavoriteService) {
        self.favoriteService = favoriteService
        self.router = router
    }
    
    // MARK: - Methods
    
    private func fetchUniversities() {
        getFavorites()
        if universities.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.delegate?.showEmptyState()
            }
        } else {
            delegate?.hideEmptyState()
            delegate?.reloadTableView()
        }
    }
    
    private func getFavorites() {
        universities = favoriteService.getFavorites()
    }
    
    private func checkEmptyState() {
        if universities.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.delegate?.showEmptyState()
            }
        }  else {
            delegate?.hideEmptyState()
        }
    }
    
    private func navigate(to route: FavoriteRoute) {
        router.navigate(to: route)
    }
    
    // MARK: TableView Methods
    
    private func numberOfUniversities() -> Int {
        universities.count
    }
    
    private func university(at index: Int) -> University? {
        universities[safe: index]
    }
    
    private func numberOfDetails(at index: Int) -> Int {
        universities[safe: index]?.details.count ?? 0
    }
    
    private func isExpanded(at index: Int) -> Bool {
        universities[safe: index]?.isExpanded ?? false
    }
    
    private func toggleExpand(at index: Int) {
        guard let university = universities[safe: index] else { return }
        guard !university.details.isEmpty else {
            delegate?.showAlert(alertMessage: AlertMessage(title: Constants.Text.warningNoDetailTitle, message: Constants.Text.warningNoDetailMessage))
            return
        }
        university.toggleExpand()
        delegate?.reloadRows(at: [IndexPath(row: index, section: 0)])
    }
    
    private func removeFavorite(with university: University) {
        
        guard
            let universityIndex = universities.firstIndex(where: { $0 == university}),
            let university = universities[safe: universityIndex]
        else {
            return
        }
        
        universities.remove(at: universityIndex)
        delegate?.deleteRows(at: [IndexPath(row: universityIndex, section: 0)])
        
        favoriteService.removeFavorite(with: university)
        
        checkEmptyState()
        
    }
    
    private func toggleAllExpanded() {
        let indexSet = universities.enumerated().compactMap { $0.element.isExpanded ? $0.offset : nil }
        universities.forEach { $0.isExpanded = false }
        
        if !indexSet.isEmpty {
            delegate?.reloadRows(at: indexSet.map { IndexPath(row: $0, section: 0) })
        }
        
    }
    
    private func removeAllFavorites() {
        let indexPaths = universities.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        
        guard !universities.isEmpty else { return }
        
        favoriteService.removeAllFavorites(universities: universities)
        universities.removeAll()
        delegate?.deleteRows(at: indexPaths)
        checkEmptyState()
    }
    
}

// MARK: - Favorite ViewModel Delegate

extension FavoriteViewModel: FavoriteViewModelProtocol {
    
    func viewDidLoad() {
        fetchUniversities()
        delegate?.prepareTableView()
        delegate?.prepareNavigationBar(title: Constants.Text.favoritesTitle)
        delegate?.prepareUI()
    }
    
    func viewDidLayoutSubviews() {
        delegate?.prepareConstraints()
    }
    
    func backButtonTapped() {
        navigate(to: .back)
    }
    
    func didSelectFavorite(university: UniversityCellViewModel) {
        guard let university = universities.first(where: { $0.name == university.universityName}) else { return }
        removeFavorite(with: university)
    }
    
    func didSelectShare(universityIndexPath: IndexPath, detailIndexPath: IndexPath) {
        guard let university = university(at: universityIndexPath.row), let detail = university.details[safe: detailIndexPath.row] else { return }
        delegate?.shareDetail(text: detail.value)
    }
    
    func didSelectDetail(universityIndexPath: IndexPath, detailIndexPath: IndexPath) {
        guard let university = university(at: universityIndexPath.row), let detail = university.details[safe: detailIndexPath.row] else { return }
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
    
    func didScaleDownButtonTapped() {
        toggleAllExpanded()
    }
    
    func didTrashButtonTapped() {
        if universities.isEmpty {
            delegate?.showAlert(alertMessage: AlertMessage(title: Constants.Text.warningNoFavoriteTitle, message: Constants.Text.warningNoFavoriteMessage))
        } else {
            delegate?.showActionSheet(alertMessage: AlertMessage(title: Constants.Text.warningRemoveAllTitle, message: Constants.Text.warningRemoveAllMessage), completion: { [weak self] in
                self?.removeAllFavorites()
            })
        }
    }
    
    func didScrollToTopButtonTapped() {
        delegate?.scrollToTop()
    }
    
    func numberOfRowsInSection(at section: Int) -> Int {
        return numberOfUniversities()
    }
    
    func cellForRow(at indexPath: IndexPath) -> UniversityCellViewModel? {
        guard let university = university(at: indexPath.row) else { return nil }
        return UniversityCellViewModel(university: university, indexPath: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        toggleExpand(at: indexPath.row)
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        isExpanded(at: indexPath.row)
        ? CGFloat ( Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * numberOfDetails(at: indexPath.row)))
        : CGFloat(Constants.UI.nonExpandCellHeight)
    }
    
    func scrollViewDidScroll(contentOffset: CGPoint) {
        contentOffset.y > 100 ? delegate?.showScrollToTopButton() : delegate?.hideScrollToTopButton()
    }
    
}
