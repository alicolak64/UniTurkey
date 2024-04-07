//
//  ResponseUniversities.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

// MARK: - Response University
struct ResponseUniversity: Codable {
    let name : String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let address: String
    let rector: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case phone = "phone"
        case fax = "fax"
        case website = "website"
        case email = "email"
        case address = "address"
        case rector = "rector"
    }
    
}

// MARK: - Response University Province
struct ResponseUniversityProvince: Codable {
    let id: Int
    let province: String
    let universities: [ResponseUniversity]

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case province = "province"
        case universities = "universities"
    }
}


// MARK: - Response Universities Page
struct ResponseUniversitiesPage: Codable {
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let itemPerPage: Int
    let pageSize: Int
    let provinces: [ResponseUniversityProvince]
    
    private enum CodingKeys: String, CodingKey {
        case currentPage = "currentPage"
        case totalPages = "totalPages"
        case totalItems = "total"
        case itemPerPage = "itemPerPage"
        case pageSize = "pageSize"
        case provinces = "data"
    }
}

