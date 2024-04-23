//
//  Expandable.swift
//  UniTurkey
//
//  Created by Ali Çolak on 22.04.2024.
//

import Foundation

protocol Expandable {
    var isExpanded: Bool { get set }
    mutating func toggleExpand()
}
