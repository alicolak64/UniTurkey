//
//  AppManager.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation

final class AppStroageManager: AppStroageService {
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    func isOnBoardingSeen() -> Bool {
        return userDefaults.bool(forKey: AppStroageKey.onBoardingSeen.rawValue)
    }
    
    func setOnBoardingSeen() {
        userDefaults.set(true, forKey: AppStroageKey.onBoardingSeen.rawValue)
    }
    
}
