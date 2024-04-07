//
//  Symbolable.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

protocol Symbolable {
    var symbolName: String { get }
    func symbol(size: CGFloat, weight: UIImage.SymbolWeight) -> UIImage
}

extension Symbolable {
    func symbol(size: CGFloat = 15, weight: UIImage.SymbolWeight = .medium) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        
        return UIImage(systemName: symbolName, withConfiguration: configuration)?
            .withRenderingMode(.alwaysTemplate) ?? UIImage()
    }
}
