//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

// MARK: - Source
protocol HomeViewModelDataSource {
    var title: String? { get set }
    var totalPages: Int { get set }
    var currentPage: Int { get set  }
    var provinces : [UniversityProvinceResponse] { get set }
    var loading: Bool { get set }
    var error: Error? { get set }
}

// MARK: - Output
enum HomeViewModelOutput {
    case updateTitle(String)
    case updateProvinces([UniversityProvinceRepresentation])
    case updateLoading(Bool)
    case updateError(Error)
}

// MARK: - Delegate
protocol HomeViewModelDelegate: AnyObject {
    func handleOutput(_ output: HomeViewModelOutput)
    func navigate(to route: HomeRoute)
}

// MARK: - Protocol
protocol HomeViewModelProtocol: HomeViewModelDataSource {
    var  delegate: HomeViewModelDelegate? { get set }
    func fetchUniversities()
    func selectUniversity(id: Int, at index: Int)
}

// MARK: - ViewModel
final class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    private let service: UniversityService
    
    var title: String?
    var totalPages: Int = 0
    var currentPage: Int = 1
    var provinces: [UniversityProvinceResponse] = []
    var loading: Bool = false
    var error: Error?
    
    init (service: UniversityService) {
        self.service = service
    }
    
}

// MARK: - ViewModel Protocol
extension HomeViewModel: HomeViewModelProtocol {
    
    func fetchUniversities() {
        
        guard currentPage < totalPages else { return }
        
        service.fetchUniversities(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.currentPage = response.currentPage
                self.totalPages = response.totalPages
                self.provinces.append(contentsOf: response.provinces)
                let presentations = self.provinces.map { UniversityProvinceRepresentation(province: $0) }
                self.notify(.updateProvinces(presentations))
            case .failure(let error):
                self.notify(.updateError(error))
            }
        }
        
    }
    
    func selectUniversity(id: Int, at index: Int) {
        guard let province = provinces.first(where: { $0.id == id }) else { return }
        guard let university = province.universities[safe: index] else { return }
        delegate?.navigate(to: .detail(university))
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleOutput(output)
    }
    
}
