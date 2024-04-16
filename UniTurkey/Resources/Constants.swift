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
        static let infinityScrollPercentage = 0.99
        static let infinityScrollLateLimitSecond = 1.0
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
    }
    
    // MARK: - Text Constant
    enum Text {
        static let homeTitleText = "Universities"
        static let notAvaliableText = "Not Avaliable"
        static let errorTitleText = "Oops! An Error Occurred"
        static let noUniversityText = "No University"
    }
    
    // MARK: - Color Constant
    enum Color {
        static let backgroundColor = UIColor(hex: "FFFFFF")
        static let blackColor = UIColor(hex: "000000")
        static let whiteColor = UIColor(hex: "FFFFFF")
        static let lightRedColor = UIColor(hex: "F44336")
        static let darkRedColor = UIColor(hex: "D62121")
        static let grayColor = UIColor(hex: "F5F5F5")
        static let borderColor = UIColor.lightGray
    }
    
    // MARK: - Font Constant
    enum Font {
        static let titleBoldFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let titleFont = UIFont.systemFont(ofSize: 32, weight: .regular)
        static let subtitleBoldFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let subtitleFont = UIFont.systemFont(ofSize: 24, weight: .regular)
        static let bodyBoldFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subBodyFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let captionBoldFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        static let captionFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let subcaptionFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        static let littleFont = UIFont.systemFont(ofSize: 8, weight: .regular)
        static let miniFont = UIFont.systemFont(ofSize: 6, weight: .regular)
    }
    
    // MARK: - Icon Constant
    enum Icon {
        private static let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        static let arrowBackIcon = UIImage(systemName: "arrowshape.backward.fill")
        static let heartIcon = UIImage(systemName: "heart", withConfiguration: largeConfig)
        static let heartFillIcon = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        static let plusIcon = UIImage(systemName: "plus")
        static let minusIcon = UIImage(systemName: "minus")
        static let phoneIcon = UIImage(systemName: "phone.fill")
        static let faxIcon = UIImage(systemName: "faxmachine")
        static let websiteIcon = UIImage(systemName: "globe")
        static let addressIcon = UIImage(systemName: "location.fill")
        static let emailIcon = UIImage(systemName: "envelope.fill")
        static let rectorIcon = UIImage(systemName: "person.fill")
        static let errorIcon = UIImage(named: "error")
    }
    
}


