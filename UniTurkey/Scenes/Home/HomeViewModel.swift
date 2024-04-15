//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

// MARK: - DataSource
protocol HomeViewModelDataSource {
    // MARK: - Properties
    var title: String? { get set }
    var totalPages: Int { get set }
    var currentPage: Int { get set  }
    var provinces : [UniversityProvinceResponse] { get set }
    var loading: Bool { get set }
    var error: Error? { get set }
}

// MARK: - Output
enum HomeViewModelOutput {
    // MARK: - Cases
    case updateTitle(String)
    case updateProvinces([UniversityProvinceRepresentation])
    case updateLoading(Bool)
    case updateError(Error)
}

// MARK: - Delegate
protocol HomeViewModelDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeRoute)
}

// MARK: - Protocol
protocol HomeViewModelProtocol: HomeViewModelDataSource {
    // MARK: - Properties
    var  delegate: HomeViewModelDelegate? { get set }
    
    // MARK: - Methods
    func fetchTitle()
    func fetchUniversities()
    func selectUniversity(id: Int, at index: Int)
    func didTryAgain()
}

// MARK: - ViewModel
final class HomeViewModel {
    
    // MARK: - Dependency Properties
    weak var delegate: HomeViewModelDelegate?
    private let service: UniversityService
    
    // MARK: - Data Source Properties
    var title: String?
    var totalPages: Int = 1
    var currentPage: Int = 0
    var provinces: [UniversityProvinceResponse] = []
    var loading: Bool = false
    var error: Error?
    
    // MARK: - Init
    init (service: UniversityService) {
        self.service = service
    }
    
}

// MARK: - ViewModel Protocol
extension HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Delegate Methods
    
    func fetchTitle() {
        notify(.updateTitle(Constants.Text.homeTitleText))
    }
    
    func fetchUniversities() {
        guard currentPage < totalPages && !loading else {  return }
        notify(.updateLoading(true))
        service.fetchUniversities(page: currentPage + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.notify(.updateLoading(false))
                self.currentPage = response.currentPage
                self.totalPages = response.totalPages
                self.provinces.append(contentsOf: response.provinces)
                let presentations = self.provinces.map { UniversityProvinceRepresentation(province: $0) }
                self.notify(.updateProvinces(presentations))
            case .failure(let error):
                self.notify(.updateLoading(false))
                self.notify(.updateError(error))
            }
        }
        
    }
    
    func selectUniversity(id: Int, at index: Int) {
        guard let province = provinces.first(where: { $0.id == id }) else { return }
        guard let university = province.universities[safe: index] else { return }
        delegate?.navigate(to: .detail(university))
    }
    
    func didTryAgain() {
        // clear all data and fetch again
        currentPage = 0
        totalPages = 1
        loading = false
        error = nil
        provinces = []
        fetchUniversities()
    }
    
    // MARK: - Delegate Notifier
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
