//
//  UniversityViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import Foundation

enum FavoriteIconState {
    case empty
    case filled
}

protocol UniversityCellViewModelProtocol {
    var universityName: String { get }
    var expansionIconState: ExpansionIconState { get }
    var favoriteIconState: FavoriteIconState { get }
    var details: [University.Detail] { get }
}

struct UniversityCellViewModel: UniversityCellViewModelProtocol {
    
    // MARK: - Properties
    
    let universityName: String
    let expansionIconState: ExpansionIconState
    let favoriteIconState: FavoriteIconState
    let details: [University.Detail]
    
    var isFavorite: Bool
    let indexPath: IndexPath
    
    // MARK: - Initializers
    
    init(university: University, indexPath: IndexPath) {
        self.universityName = university.name
        self.details = university.details
        self.indexPath = indexPath
        self.isFavorite = university.isFavorite
        self.expansionIconState = university.details.count > 0 ? ( university.isExpanded ? .minus : .plus ) : .none
        
        self.favoriteIconState = university.isFavorite ? .filled : .empty
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
    
}

