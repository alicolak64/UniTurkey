//
//  DetailViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import Foundation

enum DetailViewModelOutput {
    // MARK: Cases
    case updateTitle(String)
    case updateWebURL(URL)
}

protocol DetailViewModelDelegate: AnyObject {
    // MARK: - Methods
    func handleOutput(_ output: DetailViewModelOutput)
}

protocol DetailViewModelProtocol {
    
    // MARK: - Dependency Properties
    
    var delegate: DetailViewModelDelegate? { get set }
    
    // MARK: - Methods
    
    func fetchTitle()
    func fetchWebURL()
    
    func navigate(to route: DetailRoute)
    
}

final class DetailViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: DetailViewModelDelegate?
    private let router: DetailRouterProtocol
    
    // MARK: - Properties
    
    let university: UniversityRepresentation
    
    // MARK: - Init
    
    init(router: DetailRouterProtocol, university: UniversityRepresentation) {
        self.router = router
        self.university = university
    }
    
}

// MARK: - Detail ViewModel Delegate

extension DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Methods
    
    func fetchTitle() {
        notify(.updateTitle(university.name))
    }
    
    func fetchWebURL() {
        guard let url = university.website.httpsUrl else { return }
        notify(.updateWebURL(url))
    }
    
    
    func navigate(to route: DetailRoute) {
        router.navigate(to: route)
    }
    
    // MARK: - Helpers
    
    private func notify(_ output: DetailViewModelOutput) {
        delegate?.handleOutput(output)
    }
    
}
