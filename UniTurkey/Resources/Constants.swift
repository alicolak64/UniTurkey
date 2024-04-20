//
//  Constants.swift
//  UniTurkey
//
//  Created by Ali Çolak on 8.04.2024.
//

import UIKit

enum Constants {
    
    // MARK: - UI Constants
    
    enum UI {
        static let infinityScrollPercentage = 0.9
        static let infinityScrollLateLimitSecond = 1.0
        static let detailCellHeight = 45
        static let nonExpandCellHeight = 60
    }
    
    // MARK: - Layout Constant
    
    enum Layout {
        static let provinceCellMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        static let universityCellMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        static let detailCellMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
    }
    
    // MARK: - Network Constant
    
    enum Network {
        static let baseURL = "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey/"
        static let page = "page-"
        static let json = ".json"
        static let notAvaliableAPIText = "-"
        static let timeoutInterval = 30.0
    }
    
    // MARK: - Text Constant
    
    enum Text {
        static let homeTitle = NSLocalizedString("homeTitle", comment: "")
        static let favoritesTitle = NSLocalizedString("favoritesTitle", comment: "")
        static let notAvaliable = "Not Avaliable"
        static let errorTitle = NSLocalizedString("errorTitle", comment: "")
        static let noUniversity = NSLocalizedString("noUniversity", comment: "")
        static let noFavorite = NSLocalizedString("noFavorite", comment: "")
        static let timeoutError = NSLocalizedString("timeoutError", comment: "")
        static let multipleUniversity = NSLocalizedString("multipleUniversity", comment: "")
        static let singleUniversity = NSLocalizedString("singleUniversity", comment: "")
        static let retry = NSLocalizedString("retry", comment: "")
        static let warningNoDetailTitle = NSLocalizedString("warningNoDetailTitle", comment: "")
        static let warningNoDetailMessage = NSLocalizedString("warningNoDetailMessage", comment: "")
        static let warningNoUniversityTitle = NSLocalizedString("warningNoUniversityTitle", comment: "")
        static let warningNoUniversityMessage = NSLocalizedString("warningNoUniversityMessage", comment: "")
    }
    
    // MARK: - Color Constant
    
    enum Color {
        // adapt background color to dark mode and light mode
        static let background = UIColor.dynamicColor(light: .white, dark: .black)
        static let black = UIColor.dynamicColor(light: .black, dark: .white)
        static let white = UIColor.dynamicColor(light: .white, dark: .black)
        static let lightRed = UIColor(hex: "F44336")
        static let darkRed = UIColor(hex: "D62121")
        static let gray = UIColor(hex: "F5F5F5")
        static let border = UIColor.lightGray
    }
    
    // MARK: - Font Constant
    
    enum Font {
        static let title = UIFont.systemFont(ofSize: 32, weight: .regular)
        static let titleBold = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let subtitle = UIFont.systemFont(ofSize: 24, weight: .regular)
        static let subtitleBold = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let bodyBold = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let subBody = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let captionBold = UIFont.systemFont(ofSize: 12, weight: .bold)
        static let subcaption = UIFont.systemFont(ofSize: 10, weight: .regular)
        static let little = UIFont.systemFont(ofSize: 8, weight: .regular)
        static let mini = UIFont.systemFont(ofSize: 6, weight: .regular)
    }
    
    // MARK: - Icon Constant
    
    enum Icon {
        private static let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        static let back = UIImage(systemName: "arrowshape.backward.fill")
        static let heart = UIImage(systemName: "heart", withConfiguration: largeConfig)
        static let heartFill = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        static let plus = UIImage(systemName: "plus")
        static let minus = UIImage(systemName: "minus")
        static let phone = UIImage(systemName: "phone.fill")
        static let fax = UIImage(systemName: "faxmachine")
        static let website = UIImage(systemName: "globe")
        static let address = UIImage(systemName: "location.fill")
        static let email = UIImage(systemName: "envelope.fill")
        static let rector = UIImage(systemName: "person.fill")
        static let refresh = UIImage(systemName: "arrow.clockwise")
        static let share = UIImage(systemName: "square.and.arrow.up")
        static let scroolTop = UIImage(systemName: "chevron.up.square.fill")
        static let scaleDown = UIImage(systemName: "arrow.down.right.and.arrow.up.left.square", withConfiguration: largeConfig)
        static let error = UIImage(named: "error")
    }
    
    // MARK: - Animation
    enum Animation {
        
        // MARK: - Favorite
        
        enum Favorite {
            static let keyPath = "transform.scale"
            static let duration = 0.3
            static let keyTimes = [0, 0.25, 0.75, 1.0].map { NSNumber(value: $0) }
            static func getValues(isFavorite: Bool) -> [CGFloat] {
                return isFavorite ? [1.0, 0.7, 0.4, 0.1] : [1.0, 1.5, 0.9, 1.0]
            }
        }
        
    }
    
}


