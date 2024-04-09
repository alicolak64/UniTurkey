//
//  AppConstants.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import UIKit

enum Constants {
    
    // MARK: - UI Constants
    enum UI {
        static let infinityScrollPercentage = 0.8
        static let infinityScrollLateLimitSecond = 1.0
    }
    
    // MARK: - Network Constant
    enum Network {
        static let baseURL = "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey/"
        static let page = "page-"
        static let json = ".json"
        static let notAvaliableAPIText = "-"
    }
    
    // MARK: - Text Constant
    enum Text {
        static let notAvaliableText = "Not Avaliable"
    }
    
}


