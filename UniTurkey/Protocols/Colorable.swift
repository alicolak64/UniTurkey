//
//  Colorable.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - Colorable Protocol
protocol Colorable {
    // MARK: - Properties
    var hex: Int { get }
    var color: UIColor { get }
}

// MARK: - Default Implementation
extension Colorable {
    // MARK: - Properties
    var color: UIColor {
        return UIColor(named: String(describing: self)) ?? UIColor(rgb: hex)
    }
}
