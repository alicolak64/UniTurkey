//
//  ReusableView.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension ReusableView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
