//
//  UniversityRepresentation.swift
//  UniTurkey
//
//  Created by Ali Çolak on 9.04.2024.
//

import Foundation


class UniversityRepresentation: Codable {
    
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
    
    init(university: UniversityResponse, provinceId: Int, index: Int) {
        
        self.provinceId = provinceId
        self.index = index
        
        self.name = capitaledTrimmed(university.name)
        self.phone = trimmed(university.phone)
        self.fax = lowercasedTrimmed(university.fax)
        self.website = lowercasedTrimmed(university.website)
        self.email = trimmed(university.email)
        self.address = trimmed(university.address)
        self.rector = capitaledTrimmed(university.rector)
            
        
        func capitaledTrimmed(_ text: String) -> String {
            text == Constants.Network.notAvaliableAPIText
            ? Constants.Text.notAvaliableText
            : text.englishToTurkish.capitalCased.trimmed
        }
        
        func lowercasedTrimmed(_ text: String) -> String {
            text == Constants.Network.notAvaliableAPIText
            ? Constants.Text.notAvaliableText
            : text.lowercased().trimmed
        }
        
        func trimmed(_ text: String) -> String {
            text == Constants.Network.notAvaliableAPIText
            ? Constants.Text.notAvaliableText
            : text.trimmed
        }
    
    }
    
    func toggle() {
        isExpanded.toggle()
    }
    
}


// MARK: - University Province Representation
class UniversityProvinceRepresentation: Codable {
        
    let id: Int
    let name: String
    var universities = [UniversityRepresentation]()
    var isExpanded: Bool = false
    
    init(province: UniversityProvinceResponse) {
        self.id = province.id
        self.name =
            province.province == Constants.Network.notAvaliableAPIText
            ? Constants.Text.notAvaliableText
            : province.province.englishToTurkish.capitalCased.trimmed
        self.universities = province.universities.enumerated().map { UniversityRepresentation(university: $0.element, provinceId: id, index: $0.offset) }
    }
    
    func toggle() {
        isExpanded.toggle()
    }
    
}
