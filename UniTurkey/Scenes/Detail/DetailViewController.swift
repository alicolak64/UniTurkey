//
//  DetailViewController.swift
//  UniTurkey
//
//  Created by Ali Çolak on 18.04.2024.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {
    
    // MARK: Dependency Properties
    
    private let viewModel: DetailViewModel
    
    // MARK: Properties
    
    private var webView: WKWebView!
    
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
        refreshButton.tintColor = Constants.Color.orange
        
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        
        let refreshButtonItem = UIBarButtonItem(customView: refreshButton)
        
        return refreshButtonItem
        
    }()
    
    private lazy var navigationBarShareButton: UIBarButtonItem = {
        
        let shareButton = UIButton(type: .custom)
        
        let shareIcon = Constants.Icon.share
        shareButton.setImage(shareIcon, for: .normal)
        shareButton.tintColor = Constants.Color.blue
        
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
        viewModel.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup
    
    func prepareWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = Constants.Color.background
        view = webView
    }
    
    // MARK: - Layout
    
    func prepareUI() {
        view.backgroundColor = Constants.Color.background
    }
    
    func prepareNavigationBar(title: String) {
        navigationBarTitle.text = title
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = navigationBarBackButton
        navigationItem.rightBarButtonItems = [navigationBarRefreshButton, navigationBarShareButton]
    }
    
    func prepareConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        viewModel.didBackButtonTapped()
    }
    
    @objc private func refreshButtonTapped() {
        viewModel.didRefreshButtonTapped()
    }
    
    @objc private func shareButtonTapped() {
        viewModel.didShareButtonTapped()
    }
    
}

// MARK: - DetailViewModelDelegate

extension DetailViewController: DetailViewProtocol {
    
    func loadWebView(with request: URLRequest) {
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func reloadWebView() {
        webView.reload()
    }
    
    func showLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        if errorView.isDescendant(of: view) {
            errorView.removeFromSuperview()
        }
        loadingView.showLoading()
    }
    
    func showWebView() {
        loadingView.hideLoading()
        loadingView.removeFromSuperview()
        if errorView.isDescendant(of: view) {
            errorView.removeFromSuperview()
        }
    }
    
    func showErrorView(error: WebViewError) {
        loadingView.hideLoading()
        loadingView.removeFromSuperview()
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        errorView.showError(error: error)
    }
    
    func shareUrl(text: String) {
        share(items: [text])
    }
    
}


// MARK: - WKNavigationDelegate

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewModel.didStartProvisionalNavigation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.didFinishNavigation()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewModel.didFailNavigation(with: error)
    }
}


// MARK: - ErrorViewDelegate

extension DetailViewController: ErrorViewDelegate {
    
    func handleOutput(_ output: ErrorViewOutput) {
        switch output {
        case .retry:
            viewModel.didRetryButtonTapped()
        }
    }
}
