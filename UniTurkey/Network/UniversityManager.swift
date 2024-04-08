//
//  UniversityManager.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

// MARK: - University Manager
final class UniversityManager : UniversityService {
    
    // MARK: - Properties(Singleton)
    static let shared = UniversityManager()
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Fetch Universities
    func fetchUniversities(page: Int, completion: @escaping (Result<UniversitiesPageResponse, ServiceError>) -> Void) {
        
        guard let url = URL(string: "\(NetworkConstant.baseURL)\(NetworkConstant.page)\(page)\(NetworkConstant.json)") else {
            completion(.failure(.invalidURLError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.noConnectionError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }
            
            do {
                let universities = try JSONDecoder().decode(UniversitiesPageResponse.self, from: data)
                completion(.success(universities))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}
