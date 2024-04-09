//
//  UniversityRepresentation.swift
//  UniTurkey
//
//  Created by Ali Çolak on 9.04.2024.
//

import Foundation


// MARK: - University Representation
struct UniversityRepresentation: Codable {
    
    let university: UniversityResponse
    
    static var count: Int = -1
    
    var name: String {
        university.name == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.name.capitalizedEachWord.trimmed
    }
    
    var phone: String {
        university.phone == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.phone.trimmed
    }
    
    var fax: String {
        university.fax == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.fax.lowercased().trimmed
    }
    
    var website: String {
        university.website == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.website.lowercased().trimmed
    }
    
    var email: String {
        university.email == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.email.lowercased().trimmed
    }
    
    var address: String {
        university.address == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.address.trimmed
    }
    
    var rector: String {
        university.rector == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : university.rector.capitalizedEachWord.trimmed
    }
    
    var index: Int {
        Self.count += 1
        return Self.count
    }
    
    var isExpanded: Bool = false
    
    mutating func toggle() {
        isExpanded.toggle()
    }
    
}

// MARK: - University Province Representation
struct UniversityProvinceRepresentation: Codable {
    
    let province: UniversityProvinceResponse
    
    var id: Int {
        return province.id
    }
    
    var name: String {
        province.province == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : province.province.capitalizedEachWord.trimmed
    }
    
    var universities: [UniversityRepresentation] {
        return province.universities.map { UniversityRepresentation(university: $0) }
    }
    
    var isExpanded: Bool = false
    
    mutating func toggle() {
        isExpanded.toggle()
    }
    
}

