//
//  DetailViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import UIKit
import WebKit

enum WebViewState {
    // MARK: Cases
    case loading
    case loaded
    case error(WebViewError)
}

enum WebViewError: Error {
    // MARK: Cases
    case webKitError(Error)
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
        }
    }
}

final class DetailViewController: UIViewController {
    
    // MARK: Dependency Properties
    
    private let viewModel: DetailViewModel
    
    // MARK: Properties
    
    private var webView: WKWebView!
    
    private var webViewState: WebViewState = .loading {
        didSet {
            switch webViewState {
            case .loading:
                showLoadingView()
            case .loaded:
                showWebView()
            case .error(let error):
                showErrorView(error: error)
            }
        }
    }
    
    private var timeoutTimer: Timer?
    private var timeoutInterval: TimeInterval = 30
    
    // MARK: UI Components
    
    private lazy var navigationBarBackButton: UIBarButtonItem = {
        
        let backButton = UIButton(type: .custom)
        
        let backIcon = Constants.Icon.back
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = Constants.Color.black
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        return backButtonItem
        
    }()
    
    private lazy var navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleBold
        label.textColor = Constants.Color.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var navigationBarRefreshButton: UIBarButtonItem = {
        
        let refreshButton = UIButton(type: .custom)
        
        let refreshIcon = Constants.Icon.refresh
        refreshButton.setImage(refreshIcon, for: .normal)
        refreshButton.tintColor = Constants.Color.black
        
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        
        let refreshButtonItem = UIBarButtonItem(customView: refreshButton)
        
        return refreshButtonItem
        
    }()
    
    private lazy var navigationBarShareButton: UIBarButtonItem = {
        
        let shareButton = UIButton(type: .custom)
        
        let shareIcon = Constants.Icon.share
        shareButton.setImage(shareIcon, for: .normal)
        shareButton.tintColor = Constants.Color.black
        
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        let shareButtonItem = UIBarButtonItem(customView: shareButton)
        
        return shareButtonItem
        
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: Initializers
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        initalSetup()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    // MARK: - Setup
    
    private func initalSetup() {
        // fetch title
        viewModel.fetchTitle()
        // fetch url
        viewModel.fetchWebURL()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    // MARK: - Layout
    
    private func configureUI() {
        view.backgroundColor = Constants.Color.background
        configureNavigationBar()
        view.addSubviews()
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = navigationBarBackButton
        navigationItem.rightBarButtonItems = [navigationBarRefreshButton, navigationBarShareButton]
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        viewModel.navigate(to: .back)
    }
    
    @objc private func refreshButtonTapped() {
        webView.reload()
    }
    
    @objc private func shareButtonTapped() {
        guard let url = webView.url else {
            return
        }
        
        share(items: [url])
    }
    
    @objc private func handleTimeout() {
        webViewState = .error(WebViewError.timeoutError)
    }
    
    // MARK: Helpers
    
    private func showLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        if errorView.isDescendant(of: view) {
            errorView.removeFromSuperview()
        }
        loadingView.showLoading()
        startTimeoutTimer()
    }
    
    private func showWebView() {
        loadingView.hideLoading()
        loadingView.removeFromSuperview()
        timeoutTimer?.invalidate()
        if errorView.isDescendant(of: view) {
            errorView.removeFromSuperview()
        }
    }
    
    private func showErrorView(error: WebViewError) {
        loadingView.hideLoading()
        loadingView.removeFromSuperview()
        timeoutTimer?.invalidate()
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        errorView.showError(error: error)
    }
    
    private func startTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.scheduledTimer(timeInterval: timeoutInterval, target: self, selector: #selector(handleTimeout), userInfo: nil, repeats: false)
    }
    
}

// MARK: - WKNavigationDelegate

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewState = .loading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewState = .loaded
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewState = .error(WebViewError.webKitError(error))
    }
}

// MARK: - DetailViewModelDelegate

extension DetailViewController: DetailViewModelDelegate {
    
    func handleOutput(_ output: DetailViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            navigationBarTitle.text = title
        case .updateWebURL(let url):
            let request = URLRequest(url: url)
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
    
}

// MARK: - ErrorViewDelegate

extension DetailViewController: ErrorViewDelegate {
    
    func handleOutput(_ output: ErrorViewOutput) {
        switch output {
        case .retry:
            retryButtonTapped()
        }
    }
    
    private func retryButtonTapped() {
        viewModel.fetchWebURL()
    }
    
}


