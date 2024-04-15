//
//  UniversityRepresentation.swift
//  UniTurkey
//
//  Created by Ali Çolak on 9.04.2024.
//

import Foundation

// MARK: - University Representation
class UniversityRepresentation: Codable {
    
    // MARK: - Properties
    let name: String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let address: String
    let rector: String
    
    var isExpanded: Bool = false
    
    let provinceId: Int
    let index: Int
    
    // MARK: - Init
    init(university: UniversityResponse, provinceId: Int, index: Int) {
        
        self.provinceId = provinceId
        self.index = index
        
        self.name = university.name.apiCapitaledTrimmed
        self.phone = university.phone.apiTrimmed
        self.fax = university.fax.apiLowercasedTrimmed
        self.website = university.website.apiLowercasedTrimmed
        self.email = university.email.apiTrimmed
        self.address = university.address.apiTrimmed
        self.rector = university.rector.apiCapitaledTrimmed
        
    }
    
    // MARK: - Methods
    func toggle() {
        isExpanded.toggle()
    }
    
}

// MARK: - University Province Representation
class UniversityProvinceRepresentation: Codable {
    
    // MARK: - Properties
    let id: Int
    let name: String
    var universities = [UniversityRepresentation]()
    var isExpanded: Bool = false
    
    // MARK: - Init
    init(province: UniversityProvinceResponse) {
        self.id = province.id
        self.name = province.province.apiCapitaledTrimmed
        self.universities = province.universities.enumerated().map { UniversityRepresentation(university: $0.element, provinceId: id, index: $0.offset)
        }
    }
    
    // MARK: - Methods
    func toggle() {
        isExpanded.toggle()
    }
    
}
