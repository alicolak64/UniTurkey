//
//  UniversityService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

enum ServiceError: Error {
    case noConnectionError // No internet connection
    case invalidURLError // Invalid URL
    case serverError // Server error
    case decodingError // Decoding error
    case noDataError // No data
    case unknownError // Unknown error
}

protocol UniversityService {
    func fetchUniversities(page: Int, completion: @escaping (Result<UniversitiesPageResponse, ServiceError>) -> Void)
}

