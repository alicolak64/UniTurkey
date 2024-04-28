//
//  DetailViewModelTests.swift
//  DetailViewModelTests
//
//  Created by Ali Çolak on 28.04.2024.
//

import XCTest
@testable import UniTurkey

final class DetailViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var view: MockDetailViewController!
    private var viewModel: DetailViewModel!
    private var router: MockDetailRouter!
    private var arguments: DetailArguments!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        router = MockDetailRouter()
        arguments = DetailArguments(name: MockProvincePages.province1.universities[1].name, url: MockProvincePages.province1.universities[1].website)
        viewModel = DetailViewModel(router: router, university: arguments)
        view = MockDetailViewController()
        viewModel.delegate = view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        viewModel = nil
        arguments = nil
        router = nil
    }
    
    func prepareViewModel() {
        viewModel.loadView()
        viewModel.viewDidLoad()
        viewModel.viewDidLayoutSubviews()
    }
    
    func test_loadView_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareWebView)
        
        // When
        viewModel.loadView()
        
        // Then
        XCTAssertEqual(view.invokedPrepareWebViewCount, 1)
        
    }
    
    func test_viewDidLoad_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedLoadWebView)
        
        // When
        
        viewModel.viewDidLoad()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedLoadWebViewCount, 1)
        
        XCTAssertEqual(view.invokedPrepareNavigationBarParametersList.map( { $0.title }), [arguments.name])
        XCTAssertEqual(view.invokedLoadWebViewParametersList.map( { $0.request.url?.absoluteString }), [arguments.url.httpsUrl?.absoluteString])
        
    }
    
    func test_viewDidLayoutSubviews_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareConstraints)
        
        // When
        viewModel.viewDidLayoutSubviews()
        
        // Then
        XCTAssertEqual(view.invokedPrepareConstraintsCount, 1)
        
    }
    
    func test_backButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(router.invokedNavigate)
        
        
        // When
        prepareViewModel()
        viewModel.didBackButtonTapped()
        
        // Then
        
        XCTAssertEqual(router.invokedNavigateCount, 1)
        
    }
    
    func test_didRefreshButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedLoadWebView)
        
        // When
        prepareViewModel()
        viewModel.didRefreshButtonTapped()
        
        // Then
        
        XCTAssertEqual(view.invokedLoadWebViewCount, 1)
        
    }
    
    func test_didShareButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShareUrl)
        
        // When
        prepareViewModel()
        viewModel.didShareButtonTapped()
        
        // Then
        
        XCTAssertEqual(view.invokedShareUrlCount, 1)
        XCTAssertEqual(view.invokedShareUrlParametersList.map( { $0.text }), [arguments.url.httpsUrl?.absoluteString])
        
    }
    
    func test_didRetryButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedLoadWebView)
        
        // When
        prepareViewModel()
        viewModel.didRetryButtonTapped()
        
        // Then
        
        XCTAssertEqual(view.invokedLoadWebViewCount, 2)
        XCTAssertEqual(view.invokedLoadWebViewParametersList.map( { $0.request.url?.absoluteString }), [arguments.url.httpsUrl?.absoluteString,arguments.url.httpsUrl?.absoluteString])
        
    }
    
    func test_didStartProvisionalNavigation_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShowLoadingView)
        
        // When
        prepareViewModel()
        viewModel.didStartProvisionalNavigation()
        
        // Then
        
        XCTAssertEqual(view.invokedShowLoadingViewCount, 1)
        
    }
    
    func test_didFinishNavigation_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShowWebView)
        
        // When
        prepareViewModel()
        viewModel.didFinishNavigation()
        
        // Then
        
        XCTAssertEqual(view.invokedShowWebViewCount, 1)
        
    }
    
    func test_didFailNavigation_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShowErrorView)
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        
        // When
        prepareViewModel()
        viewModel.didFailNavigation(with: error)
        
        // Then
        
        XCTAssertEqual(view.invokedShowErrorViewCount, 1)
        XCTAssertEqual(view.invokedShowErrorViewParametersList.map( { $0.error.localizedDescription }), [error.localizedDescription])
        
    }
    
    func test_didFailTimeout_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShowLoadingView)
        XCTAssertFalse(view.invokedShowWebView)
        XCTAssertFalse(view.invokedShowErrorView)
        let error : WebViewError = .timeoutError
        
        let timeout = Constants.Network.timeoutInterval + 1
        
        // When
        prepareViewModel()
        viewModel.didStartProvisionalNavigation()
        
        let expectation = self.expectation(description: "Timeout")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout + 1, handler: nil)
        
        // Then
        
        XCTAssertEqual(view.invokedShowLoadingViewCount, 1)
        XCTAssertEqual(view.invokedShowWebViewCount, 0)
        XCTAssertEqual(view.invokedShowErrorViewCount, 1)
        XCTAssertEqual(view.invokedShowErrorViewParametersList.map( { $0.error.localizedDescription }), [error.localizedDescription])
        
    }
    
}
