//
//  BaseNavigationController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    //MARK: - Prepare
    private func prepare() {
        setBarApperance()
    }

    //MARK: - Private
    private func setBarApperance() {
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
}
