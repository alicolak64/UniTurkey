//
//  ReusableView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - ReusableView Protocol
protocol ReusableView: AnyObject {
    // MARK: - Associated Type
    associatedtype Model
    
    // MARK: - Properties
    static var identifier: String { get }
    
    // MARK: - Methods
    func configure(with model: Model)
}

// MARK: Default Implementation
extension ReusableView where Self: UIView {
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
}
