//
//  FavoriteContracts.swift
//  UniTurkey
//
//  Created by Ali Çolak on 23.04.2024.
//

import UIKit

protocol DetailBuilderProtocol {
    
    // MARK: - Methods
    
    func build(with university: DetailArguments) -> UIViewController
}

enum DetailRoute {
    // MARK: Cases
    case back
}

protocol DetailRouterProtocol {
    // MARK: Dependency Properties
    var navigationController: UINavigationController? { get }
    // MARK: Methods
    func navigate(to route: DetailRoute)
}


protocol DetailViewModelProtocol {
    
    // MARK: - Dependency Properties
    var delegate: DetailViewProtocol? { get set }
    
    // MARK: - Lifecycle Methods
    func loadView()
    func viewDidLoad()
    func viewDidLayoutSubviews()
    
    func didBackButtonTapped()
    func didRefreshButtonTapped()
    func didShareButtonTapped()
    func didRetryButtonTapped()
    
    func didStartProvisionalNavigation()
    func didFinishNavigation()
    func didFailNavigation(with error: Error)
    
}

protocol DetailViewProtocol: AnyObject {
    
    // MARK: - Lifecycle Methods
    func loadView()
    func viewDidLoad()
    func viewDidLayoutSubviews()
    
    func prepareWebView()
    func prepareNavigationBar(title: String)
    func prepareUI()
    func prepareConstraints()
    
    func loadWebView(with request: URLRequest)
    func showLoadingView()
    func showWebView()
    func showErrorView(error: WebViewError)
    func reloadWebView()
    
    func shareUrl(text: String)
}

enum WebViewState {
    // MARK: Cases
    case loading
    case loaded
    case error(WebViewError)
}

enum WebViewError: Error {
    // MARK: Cases
    case webKitError(Error)
    case invalidURL
    case timeoutError
}

// MARK: - LocalizedError

extension WebViewError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .webKitError(let error):
            return error.localizedDescription
        case .timeoutError:
            return Constants.Text.timeoutError
        case .invalidURL:
            return "Invalid URL error"
        }
    }
}

