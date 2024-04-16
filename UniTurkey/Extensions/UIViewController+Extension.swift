//
//  UIViewController+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 7.04.2024.
//

import UIKit

extension UIViewController {
    // MARK: - Show Alert
    func showAlert(title: String, message: String, actionTitle: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}


