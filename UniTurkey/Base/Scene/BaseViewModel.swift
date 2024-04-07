//
//  BaseViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import Foundation

// MARK: - Delegate
protocol BaseViewModelDelegate: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
}

extension BaseViewModelDelegate {
    func viewDidLoad() {
        print("View Did Not Overriden")
    }
    func viewWillAppear() {
        print("View Did Not Overriden")
    }
    func viewDidDisappear() {
        print("View Did Not Overriden")
    }
}

// MARK: - Source
protocol BaseViewModelDataSource { }

// MARK: - Protocol
protocol BaseViewModelProtocol: BaseViewModelDataSource { }

class BaseViewModel<R: BaseRouter>: BaseViewModelProtocol {
    
    typealias Router = R
    
    // MARK: - Dependency
    private let router: Router
    
    deinit {
        // TODO: - create a custom logger
    }
    
    required init(router: Router) {
        self.router = router
    }
}
