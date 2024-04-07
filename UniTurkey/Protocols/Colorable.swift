//
//  Colorable.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

protocol Colorable {
    var hex: Int { get }
    var color: UIColor { get }
}

extension Colorable {
    var color: UIColor {
        return UIColor(named: String(describing: self)) ?? UIColor(rgb: hex)
    }
}
