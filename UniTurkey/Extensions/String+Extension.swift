//
//  String+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 7.04.2024.
//

import Foundation

extension String {
    
    // MARK: - Properties
    var capitalizedEachWord: String {
        let words = self.components(separatedBy: " ")
        var capitalizedWords = [String]()
        for word in words {
            if let firstLetter = word.first {
                let capitalizedWord = String(firstLetter).uppercased() + word.dropFirst()
                capitalizedWords.append(capitalizedWord)
            }
        }
        return capitalizedWords.joined(separator: " ")
    }
    
    @discardableResult
    mutating func capitalizeEachWord() -> String {
        self = self.components(separatedBy: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
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
    
}
