//
//  IndexPath+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation

extension IndexPath {
    
    var isSection: Bool {
        return row == 0
    }
    
    var indexWithSection: IndexPath {
        return IndexPath(row: row + 1, section: section)
    }
    
    var indexWithoutSection: IndexPath {
        return IndexPath(row: row - 1, section: section)
    }
    
}

