//
//  MockDetailViewController.swift
//  DetailViewModelTests
//
//  Created by Ali Çolak on 28.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockDetailViewController: DetailViewProtocol {
    
    var invokedPrepareWebView = false
    var invokedPrepareWebViewCount = 0
    
    func prepareWebView() {
        invokedPrepareWebView = true
        invokedPrepareWebViewCount += 1
    }
    
    var invokedPrepareNavigationBar = false
    var invokedPrepareNavigationBarCount = 0
    var invokedPrepareNavigationBarParameters: (title: String, Void)?
    var invokedPrepareNavigationBarParametersList = [(title: String, Void)]()
    
    func prepareNavigationBar(title: String) {
        invokedPrepareNavigationBar = true
        invokedPrepareNavigationBarCount += 1
        invokedPrepareNavigationBarParameters = (title, ())
        invokedPrepareNavigationBarParametersList.append((title, ()))
    }
    
    var invokedPrepareUI = false
    var invokedPrepareUICount = 0
    
    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }
    
    var invokedPrepareConstraints = false
    var invokedPrepareConstraintsCount = 0
    
    func prepareConstraints() {
        invokedPrepareConstraints = true
        invokedPrepareConstraintsCount += 1
    }
    
    var invokedLoadWebView = false
    var invokedLoadWebViewCount = 0
    var invokedLoadWebViewParameters: (request: URLRequest, Void)?
    var invokedLoadWebViewParametersList = [(request: URLRequest, Void)]()
    
    func loadWebView(with request: URLRequest) {
        invokedLoadWebView = true
        invokedLoadWebViewCount += 1
        invokedLoadWebViewParameters = (request, ())
        invokedLoadWebViewParametersList.append((request, ()))
    }
    
    var invokedShowLoadingView = false
    var invokedShowLoadingViewCount = 0
    
    func showLoadingView() {
        invokedShowLoadingView = true
        invokedShowLoadingViewCount += 1
    }
    
    var invokedShowWebView = false
    var invokedShowWebViewCount = 0
    
    func showWebView() {
        invokedShowWebView = true
        invokedShowWebViewCount += 1
    }
    
    var invokedShowErrorView = false
    var invokedShowErrorViewCount = 0
    var invokedShowErrorViewParameters: (error: UniTurkey.WebViewError, Void)?
    var invokedShowErrorViewParametersList = [(error: UniTurkey.WebViewError, Void)]()
    
    func showErrorView(error: UniTurkey.WebViewError) {
        invokedShowErrorView = true
        invokedShowErrorViewCount += 1
        invokedShowErrorViewParameters = (error, ())
        invokedShowErrorViewParametersList.append((error, ()))
    }
    
    var invokedReloadWebView = false
    var invokedReloadWebViewCount = 0
    
    func reloadWebView() {
        invokedReloadWebView = true
        invokedReloadWebViewCount += 1
    }
    
    var invokedShareUrl = false
    var invokedShareUrlCount = 0
    var invokedShareUrlParameters: (text: String, Void)?
    var invokedShareUrlParametersList = [(text: String, Void)]()
    
    func shareUrl(text: String) {
        invokedShareUrl = true
        invokedShareUrlCount += 1
        invokedShareUrlParameters = (text, ())
        invokedShareUrlParametersList.append((text, ()))
    }
    
    
}
