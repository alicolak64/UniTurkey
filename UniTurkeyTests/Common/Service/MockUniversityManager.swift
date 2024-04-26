//
//  MockUniversityManager.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockUniversityManager: UniversityService {
    
    enum Completion {
        case page
        case invalidURLError
        case noConnectionError
        case noDataError
    }
    
    var completionCase: Completion = .page
    
    // MARK: - Methods
    
    func fetchProvinces(page: Int, completion: @escaping (Result<UniTurkey.ProvincePageResponse, UniTurkey.ServiceError>) -> Void) {
                
        switch completionCase {
        case .page:
            if let response = getProvinces(page: page) {
                completion(.success(response))
            } else {
                completion(.failure(.decodingError))
            }
        case .invalidURLError:
            completion(.failure(.invalidURLError))
        case .noConnectionError:
            completion(.failure(.noConnectionError))
        case .noDataError:
            completion(.failure(.noDataError))
        }
        
    }
    
    private func getProvinces(page: Int) -> ProvincePageResponse? {
        
        switch page {
        case 1: 
            return MockProvincePages.getProvincePage(page: .page1)
        case 2:
            return MockProvincePages.getProvincePage(page: .page2)
        case 3:
            return MockProvincePages.getProvincePage(page: .page3)
        default:
            return nil
        }
        
    }

    
}
