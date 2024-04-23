//
//  ProvinceViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import Foundation

enum ExpansionIconState {
    case plus
    case minus
    case none
}

protocol ProvinceCellViewModelProtocol {
    var provinceName: String { get }
    var universityCountText: String { get }
    var expansionIconState: ExpansionIconState { get }
}

struct ProvinceCellViewModel: ProvinceCellViewModelProtocol {
    
    // MARK: - Properties
    
    let provinceName: String
    let universityCountText: String
    let expansionIconState: ExpansionIconState
    
    // MARK: - Initializers
    
    init(province: Province) {
        self.provinceName = province.name
        
        let count = province.universities.count
        
        self.universityCountText = count > 1 ? "\(count) \(Constants.Text.multipleUniversity)" : ( count == 1 ? "\(count) \(Constants.Text.singleUniversity)" : Constants.Text.noUniversity)
        
        self.expansionIconState = count > 0 ? ( province.isExpanded ? .minus : .plus ) : .none
    }
    
}




