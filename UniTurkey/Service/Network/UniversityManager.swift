//
//  UniversityManager.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import Foundation

final class UniversityManager: UniversityService {
    
    // MARK: - Properties(Singleton)
    
    static let shared = UniversityManager()
    
    // MARK: - Private Initializer
    
    private init() {}
    
    // MARK: - Methods
    
    func fetchProvinces(page: Int, completion: @escaping (Result<ProvincePageResponse, ServiceError>) -> Void) {
        
        guard let url = URL(string: "\(Constants.Network.baseURL)\(Constants.Network.page)\(page)\(Constants.Network.json)") else {
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
                let universities = try JSONDecoder().decode(ProvincePageResponse.self, from: data)
                completion(.success(universities))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}
