//
//  ColorBackground.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum ColorBackground: Colorable {
    case backgroundPrimary
    
    var hex: Int {
        switch self {
        case .backgroundPrimary:
            return 0xFFFFFF
        }
    }
}
