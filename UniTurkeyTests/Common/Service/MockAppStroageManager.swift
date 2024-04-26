//
//  MockAppStroageManager.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockAppStroageManager: AppStroageService{
    
    // MARK: - Properties
    var onBoardingSeen: Bool = false
    
    func isOnBoardingSeen() -> Bool {
        return onBoardingSeen
    }
    
    func setOnBoardingSeen() {
        onBoardingSeen = true
    }
    
}
