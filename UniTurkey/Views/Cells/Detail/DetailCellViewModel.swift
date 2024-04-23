//
//  DetailCellViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import Foundation

protocol DetailCellViewModelProtocol {
    var detailIconType: University.DetailCategory { get }
    var detailText: String { get }
    var indexPath: IndexPath { get }
}

struct DetailCellViewModel: DetailCellViewModelProtocol {
    
    // MARK: - Properties
    
    let detailIconType: University.DetailCategory
    let detailText: String
    let indexPath: IndexPath
    
    // MARK: - Initializers
    
    init(detail: University.Detail, indexPath: IndexPath) {
        self.detailIconType = detail.category
        self.detailText = detail.value
        self.indexPath = indexPath
    }
    
}
