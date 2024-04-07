//
//  HomeViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

// MARK: - Source
protocol HomeViewModelDataSource: BaseViewModelDataSource {
    var title: String? { get }
}

// MARK: - Delegate
protocol HomeViewModelDelegate : BaseViewModelDelegate {
    func didUpdateTitle(title: String)
}

// MARK: - Protocol
protocol HomeViewModelProtocol: HomeViewModelDataSource {
    func getTitle()
}

// MARK: - ViewModel
final class HomeViewModel: BaseViewModel<HomeRouter> {
    
    weak var delegate: HomeViewModelDelegate?
    
    var title: String? { "Turkey Universities Home" }
    
}

extension HomeViewModel: HomeViewModelProtocol {
    func getTitle() {
        delegate?.didUpdateTitle(title: title ?? "Title Not Found")
    }
}
