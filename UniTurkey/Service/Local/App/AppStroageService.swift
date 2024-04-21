//
//  AppService.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation

enum AppStroageKey: String {
    case onBoardingSeen
}

protocol AppStroageService{
    func isOnBoardingSeen() -> Bool
    func setOnBoardingSeen()
}
