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
    
    // MARK: - Methods
    
    @discardableResult
    mutating func capitalCase() -> String {
        self = self.capitalCased
        return self
    }
    
}

// MARK: - API String Extension

extension String {
    
    // MARK: - Properties
    
    var apiCapitaledTrimmed: String {
        return self == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : self.englishToTurkish.capitalCased.trimmed
    }
    
    var apiLowercasedTrimmed: String {
        return self == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : self.lowercased().trimmed
    }
    
    var apiTrimmed: String {
        return self == Constants.Network.notAvaliableAPIText
        ? Constants.Text.notAvaliableText
        : self.trimmed
    }
    
    var isNotAvaliable: Bool {
        return self == Constants.Text.notAvaliableText
    }
}

// MARK: - Detail String Extension

extension String {
    
    // MARK: - Properties
    
    var phoneUrl: URL? {
        return URL(string: "tel://\(self)")
    }
    
    var emailUrl: URL? {
        return URL(string: "mailto:\(self)")
    }
    
    var safariUrl: URL? {
        return URL(string: "x-web-search://?\(self)")
    }
    
}

// MARK: - WebWiew String Extension

extension String {
    
    // MARK: - Properties
    
    var httpsUrl: URL? {
        // if it doesn't start  https:// add it
        
        // if it start  https but wrong format
        if self.hasPrefix("https") {
            if self.contains("https://") {
                return URL(string: self)
            } else if self.contains("https:/") {
                return URL(string: self.replacingOccurrences(of: "https:/", with: "https://"))
            } else if self.contains("https:") {
                return URL(string: self.replacingOccurrences(of: "https:", with: "https://"))
            } else{
                return URL(string: self.replacingOccurrences(of: "https", with: "https://"))
            }
        }
        
        // if it starts with http
        if self.hasPrefix("http") {
            
            if self.contains("http://") {
                return URL(string: self.replacingOccurrences(of: "http://", with: "https://"))
            } else if self.contains("http:/") {
                return URL(string: self.replacingOccurrences(of: "http:/", with: "https://"))
            } else if self.contains("http:") {
                return URL(string: self.replacingOccurrences(of: "http:", with: "https:"))
            } else {
                return URL(string: self.replacingOccurrences(of: "http", with: "https://"))
            }
            
        }
        
        if !self.hasPrefix("https") {
            return URL(string: "https://\(self)")
        }
        
        return URL(string: self)
    }
    
}
