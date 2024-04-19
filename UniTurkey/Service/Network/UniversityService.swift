//
//  UniversityService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

enum ServiceError: Error {
    // MARK: Cases
    case noConnectionError
    case invalidURLError // Invalid URL
    case serverError // Server error
    case decodingError // Decoding error
    case noDataError // No data
    case unknownError // Unknown error
}

// MARK: - LocalizedError

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnectionError:
            return "No connection error"
        case .invalidURLError:
            return "Invalid URL error"
        case .serverError:
            return "Server error"
        case .decodingError:
            return "Decoding error"
        case .noDataError:
            return "No data error"
        case .unknownError:
            return "Unknown error"
        }
    }
}

protocol UniversityService {
    // MARK: - Methods
    func fetchProvinces(page: Int, completion: @escaping (Result<ProvincePageResponse, ServiceError>) -> Void)
}

