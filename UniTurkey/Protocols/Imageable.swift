//
//  Imageable.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - Imageable Protocol
protocol Imageable {
    // MARK: - Properties
    var image: UIImage { get }
}

// MARK: - Default Implementation
extension Imageable {
    // MARK: - Properties
    var image: UIImage {
        UIImage(named: String(describing: self)) ?? UIImage()
    }
}
