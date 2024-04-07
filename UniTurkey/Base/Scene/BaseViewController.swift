//
//  BaseViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

// MARK: - ViewModel Delegate
extension BaseViewController: BaseViewModelDelegate {
    
}

class BaseViewController<V: BaseViewModelProtocol>: UIViewController {
    
    typealias ViewModel = V
    
    // MARK: - Dependency
    let viewModel: ViewModel
    
    // MARK: - Init
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // TODO: - create a custom logger
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    // MARK: - Prapare
    func prepare() {
        // Additional setup code can be placed here
        view.backgroundColor = ColorBackground.backgroundPrimary.color
    }
    
}


