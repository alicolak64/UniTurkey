//
//  UniversityResponse.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

struct UniversityResponse: Codable {
    
    // MARK: - Properties
    let name : String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let address: String
    let rector: String
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case phone = "phone"
        case fax = "fax"
        case website = "website"
        case email = "email"
        case address = "adress"
        case rector = "rector"
    }
    
}

struct UniversityProvinceResponse: Codable {
    
    // MARK: - Properties
    let id: Int
    let province: String
    let universities: [UniversityResponse]
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case province = "province"
        case universities = "universities"
    }
}


struct UniversitiesPageResponse: Codable {
    
    // MARK: - Properties
    let currentPage: Int
    let totalPages: Int
    let totalProvinces: Int
    let provincePerPage: Int
    let pageSize: Int
    let provinces: [UniversityProvinceResponse]
    
    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case currentPage = "currentPage"
        case totalPages = "totalPage"
        case totalProvinces = "total"
        case provincePerPage = "itemPerPage"
        case pageSize = "pageSize"
        case provinces = "data"
    }
}


