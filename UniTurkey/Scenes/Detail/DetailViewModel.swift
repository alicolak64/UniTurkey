//
//  DetailViewModel.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import Foundation

final class DetailViewModel {
    
    // MARK: - Dependency Properties
    
    weak var delegate: DetailViewProtocol?
    private let router: DetailRouterProtocol
    
    // MARK: - Properties
    
    private let university: DetailArguments
    
    private var webViewState: WebViewState = .loading {
        didSet {
            switch webViewState {
            case .loading:
                delegate?.showLoadingView()
                startTimeoutTimer()
            case .loaded:
                delegate?.showWebView()
                timeoutTimer?.invalidate()
            case .error(let error):
                delegate?.showErrorView(error: error)
                timeoutTimer?.invalidate()
            }
        }
    }
    
    private var timeoutTimer: Timer?
    private var timeoutInterval: TimeInterval = Constants.Network.timeoutInterval
    
    // MARK: - Init
    
    init(router: DetailRouterProtocol, university: DetailArguments) {
        self.router = router
        self.university = university
    }
    
    private func loadWebView() {
        guard let url = university.url.httpsUrl else {
            webViewState = .error(.invalidURL)
            return
        }
        
        delegate?.loadWebView(with: URLRequest(url: url))
    }
    
    private func navigate(to route: DetailRoute) {
        router.navigate(to: route)
    }
    
    private func startTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.scheduledTimer(timeInterval: timeoutInterval, target: self, selector: #selector(handleTimeout), userInfo: nil, repeats: false)
    }
    
    @objc private func handleTimeout() {
        webViewState = .error(WebViewError.timeoutError)
    }
    
}

// MARK: - Detail ViewModel Delegate

extension DetailViewModel: DetailViewModelProtocol {
    
    func loadView() {
        delegate?.prepareWebView()
    }
    
    func viewDidLoad() {
        delegate?.prepareNavigationBar(title: university.name)
        delegate?.prepareUI()
        loadWebView()
    }
    
    func viewDidLayoutSubviews() {
        delegate?.prepareConstraints()
    }
    
    func didBackButtonTapped() {
        navigate(to: .back)
    }
    
    func didRefreshButtonTapped() {
        delegate?.reloadWebView()
    }
    
    func didShareButtonTapped() {
        guard let url = university.url.httpsUrl else {
            delegate?.shareUrl(text: "Invalid URL")
            return
        }
        delegate?.shareUrl(text: url.absoluteString)
    }
    
    func didRetryButtonTapped() {
        loadWebView()
    }
    
    func didStartProvisionalNavigation() {
        webViewState = .loading
    }
    
    func didFinishNavigation() {
        webViewState = .loaded
    }
    
    func didFailNavigation(with error: Error) {
        webViewState = .error(.webKitError(error))
    }
    
}
