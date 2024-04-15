//
//  ReusableView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

protocol ReusableView: AnyObject {
    associatedtype Model
    static var identifier: String { get }
    func configure(with model: Model)
}

extension ReusableView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
