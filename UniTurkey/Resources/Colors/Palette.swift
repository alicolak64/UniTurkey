//
//  Palette.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

enum Palette: Colorable {
    case white
    case black
    
    var hex: Int {
        switch self {
        case .white:
            return 0xFFFFFF
        case .black:
            return 0x000000
        }
    }
}
