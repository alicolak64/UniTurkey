//
//  AppDelegate.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Did Finish Launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        app.router.start() // Start the app
        return true
    }
    
}

