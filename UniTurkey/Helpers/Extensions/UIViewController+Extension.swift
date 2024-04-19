//
//  UIViewController+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 7.04.2024.
//

import UIKit
import CoreLocation
import MapKit


extension UIViewController {
    
    // MARK: - Show Alert
    
    func showAlert(title: String, message: String, actionTitle: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func share(items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Call Phone
        
    func callPhone(with phone: String) {
        guard let phoneURL = phone.phoneUrl else {
            showAlert(title: "Warning! No Phone Number", message: "There is no phone number to call.", actionTitle: "OK")
            return
        }
        guard UIApplication.shared.canOpenURL(phoneURL) else {
            showAlert(title: "Warning! Invalid Phone Number", message: "The phone number is invalid.", actionTitle: "OK")
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(phoneURL)
        }
    
    }
    
    // MARK: - Send Email
    
    func sendEmail(with email: String) {
        
        guard let emailUrl = email.emailUrl else {
            showAlert(title: "Warning! No Email Address", message: "There is no email address to send email.", actionTitle: "OK")
            return
        }
        
        guard UIApplication.shared.canOpenURL(emailUrl) else {
            showAlert(title: "Warning! Invalid Email Address", message: "The email address is invalid.", actionTitle: "OK")
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(emailUrl)
        }
        
    }
    
    // MARK: - Open Map Address
    
    func openMapAddress(with address: String) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = address
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: "An error occurred while searching the address: \(error.localizedDescription)", actionTitle: "OK")
                return
            }
            
            guard let mapItems = response?.mapItems, let firstItem = mapItems.first else {
                self.showAlert(title: "Warning! No Address Found", message: "The address could not be found.", actionTitle: "OK")
                return
            }
            
            let mapItem = MKMapItem(placemark: firstItem.placemark)
            mapItem.name = address
            mapItem.openInMaps(launchOptions: nil)
            
        }
        
        
        
    }
    
    // MARK: - Search Text in Safari
    
    func searchTextSafari(with text: String) {
        
        guard let url = text.safariUrl else {
            showAlert(title: "Warning! Invalid URL", message: "The URL is invalid.", actionTitle: "OK")
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            showAlert(title: "Warning! Invalid URL", message: "The URL is invalid.", actionTitle: "OK")
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}


