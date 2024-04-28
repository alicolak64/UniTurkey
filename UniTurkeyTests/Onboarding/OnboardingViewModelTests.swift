//
//  OnboardingViewModelTests.swift
//  OnboardingViewModelTests
//
//  Created by Ali Çolak on 27.04.2024.
//

import XCTest
@testable import UniTurkey

final class OnboardingViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var view: MockOnboardingViewController!
    private var viewModel: OnboardingViewModel!
    private var router: MockOnboardingRouter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        router = MockOnboardingRouter()
        viewModel = OnboardingViewModel(router: router)
        view = MockOnboardingViewController()
        viewModel.delegate = view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        viewModel = nil
        router = nil
    }
    
    func prepareViewModel() {
        viewModel.viewDidLoad()
        viewModel.viewDidLayoutSubviews()
    }
    
    func test_viewDidLoad_InvokesRequiredMethods() {
        
        // Given
        
        XCTAssertFalse(view.invokedPrepareOnboarding)
        XCTAssertFalse(view.invokedPrepareUI)
        
        // When
        
        viewModel.viewDidLoad()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareOnboardingCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        
    }
    
    func test_viewDidLayoutSubviews_InvokesRequiredMethods() {
        
        // Given
        
        XCTAssertFalse(view.invokedPrepareConstraints)
        
        // When
        
        viewModel.viewDidLayoutSubviews()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareConstraintsCount, 1)
        
    }
    
    func test_didSkipButtonTapped_InvokesRouterMethod() {
        
        // Given
        
        XCTAssertFalse(router.invokedNavigate)
        
        // When
        
        viewModel.didSkipButtonTapped()
        
        // Then
        
        XCTAssertEqual(router.invokedNavigateCount, 1)
        
    }
    
    func test_numberOfPages_ReturnsCorrectValue() {
        
        // Given
            
        let expectedValue = Constants.Onboarding.titles.count
        
        prepareViewModel()
        
        // When
                
        let result = viewModel.numberOfPages()
        
        // Then
        
        XCTAssertEqual(result, expectedValue)
        
    }
    
    func test_onboardingWillTransitonToIndex_InvokesViewMethod() {
        
        // Given
        
        XCTAssertFalse(view.invokedShowSkipButton)
        
        let index = Constants.Onboarding.titles.count - 1
        
        prepareViewModel()
        
        // When
                
        viewModel.onboardingWillTransitonToIndex(at: index)
        
        // Then
        
        XCTAssertEqual(view.invokedShowSkipButtonCount, 1)
        
    }
    
    func test_onboardingDidTransitonToIndex_InvokesHideMethod() {
        
        // Given
        
        XCTAssertFalse(view.invokedHideSkipButton)
        
        let index = Constants.Onboarding.titles.count - 2
        
        prepareViewModel()
        
        // When
            
        viewModel.onboardingWillTransitonToIndex(at: index)
        
        // Then
        
        XCTAssertEqual(view.invokedHideSkipButtonCount, 1)
        
    }
    
    func test_pageForItemAt_withFirstPage_ReturnsCorrectValue() {
        
        // Given
        
        let index = 0
        let expectedValue = Constants.Onboarding.titles[index]
        
        prepareViewModel()
        
        // When
                
        let result = viewModel.pageForItem(at: index).title
        
        // Then
        
        XCTAssertEqual(result, expectedValue)
        
    }
    
    func test_pageForItemAt_withLastPage_ReturnsCorrectValue() {
        
        // Given
        
        let index = Constants.Onboarding.titles.count - 1
        let expectedValue = Constants.Onboarding.titles[index]
        
        prepareViewModel()
        
        // When
            
        let result = viewModel.pageForItem(at: index).title
        
        // Then
        
        XCTAssertEqual(result, expectedValue)
        
    }
    
}

