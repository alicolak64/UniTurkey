//
//  String+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 7.04.2024.
//

import Foundation

extension String {
    
    // MARK: - Properties
    var capitalCased: String {
        let components = self.components(separatedBy: " ")
        let capitalized = components.map { $0.capitalized }
        return capitalized.joined(separator: " ")
    }
    
    @discardableResult
    mutating func capitalCase() -> String {
        self = self.capitalCased
        return self
    }
    
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    var int: Int? {
        return Int(self)
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var englishToTurkish: String {
        return self.replacingOccurrences(of: "I", with: "ı")
    }
    
}
