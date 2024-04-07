//
//  ColorText.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum ColorText: Colorable {
    case whiteText
    
    var hex: Int {
        switch self {
        case .whiteText:
            return 0x000000
        }
    }
}
