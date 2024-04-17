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
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


