//
//  UniversityRepresentation.swift
//  UniTurkey
//
//  Created by Ali Çolak on 9.04.2024.
//

import Foundation

class UniversityRepresentation: Codable {
    
    // MARK: Enums
    
    enum DetailCategory {
        // MARK: Cases
        case phone
        case fax
        case website
        case email
        case address
        case rector
    }
    
    // MARK: - Structs
    
    struct Detail {
        // MARK: - Properties
        let category: DetailCategory
        let value: String
    }
    
    // MARK: - Properties
    
    let name: String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let address: String
    let rector: String
    
    var isExpanded: Bool = false
    var isFavorite: Bool = false
    
    let provinceId: Int
    let index: Int
    
    // MARK: - Computed Properties
    
    var details: [Detail] {
        return [
            Detail(category: .phone, value: phone),
            Detail(category: .fax, value: fax),
            Detail(category: .website, value: website),
            Detail(category: .email, value: email),
            Detail(category: .address, value: address),
            Detail(category: .rector, value: rector)
        ].filter { !$0.value.isNotAvaliable }
    }
    
    
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
    
    func toggleExpand() {
        isExpanded.toggle()
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
    
}

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
    
    func toggleExpand() {
        isExpanded.toggle()
    }
    
}
