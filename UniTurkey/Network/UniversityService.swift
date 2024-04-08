//
//  UniversityService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

// MARK: - Service Error Enum
enum ServiceError: Error {
    case noConnectionError // No internet connection
    case invalidURLError // Invalid URL
    case serverError // Server error
    case decodingError // Decoding error
    case noDataError // No data
    case unknownError // Unknown error
}

// MARK: - University Service Protocol
protocol UniversityService {
    func fetchUniversities(page: Int, completion: @escaping (Result<UniversitiesPageResponse, ServiceError>) -> Void)
}

