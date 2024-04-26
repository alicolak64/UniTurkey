//
//  UniTurkeyTests.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 7.04.2024.
//

import XCTest
@testable import UniTurkey

final class UniTurkeyTests: XCTestCase {
    
    // MARK: - Properties
    private var view: MockHomeViewController!
    private var viewModel: HomeViewModel!
    private var favoriteService: MockFavoriteManager!
    private var universityService: MockUniversityManager!
    private var router: MockHomeRouter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favoriteService = MockFavoriteManager()
        universityService = MockUniversityManager()
        router = MockHomeRouter()
        viewModel = HomeViewModel(router: router,
                                  universityService: universityService,
                                  favoriteService: favoriteService)
        view = MockHomeViewController()
        viewModel.delegate = view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        viewModel = nil
        favoriteService = nil
        universityService = nil
        router = nil
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenAPISuccess() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedStopLoading)
        
        // When
        viewModel.viewDidLoad()
        
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedStartLoadingCount, 1)
        XCTAssertEqual(view.invokedStopLoadingCount, 1)
        
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenAPIFailure() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedStopLoading)
        
        // When
        universityService.completionCase = .noDataError
        viewModel.viewDidLoad()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedStartLoadingCount, 1)
        
        let expectation = XCTestExpectation(description: "ViewDidLoad completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak view] in
            guard let view = view else { XCTFail("View is nil"); return }
            XCTAssertEqual(view.invokedShowErrorCount, 1)
            XCTAssertEqual(view.invokedStopLoadingCount, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
    }
    
    func test_viewWillAppear_InvokesRequiredMethods_whenAPISuccess() {
        
        // Given
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        
        // Then
        XCTAssertEqual(view.invokedReloadTableViewCount, 2)
        
    }
    
    func test_viewWillAppear_InvokesRequiredMethods_whenAPIFailure() {
        
        // Given
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        universityService.completionCase = .noConnectionError
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        
        // Then
        XCTAssertEqual(view.invokedReloadTableViewCount, 0)
        
    }
    
    func test_viewDidLayoutSubviews_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareConstraints)
        
        // When
        viewModel.viewDidLayoutSubviews()
        
        // Then
        XCTAssertEqual(view.invokedPrepareConstraintsCount, 1)
        
    }
    
    func test_didFavoriteButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(router.invokedNavigate)
        
        // When
        viewModel.didFavoriteButtonTapped()
        
        // Then
        XCTAssertEqual(router.invokedNavigateCount, 1)
        
    }
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenProvinceNonExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        XCTAssertFalse(view.invokedReloadSections)
        
        // When
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 0)
        XCTAssertEqual(view.invokedReloadSectionsCount, 0)
        
    }
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenProvinceExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        XCTAssertFalse(view.invokedReloadSections)
        
        // When
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.didSelectRow(at: IndexPath(row: 0, section: 0)) // expand province in first cell
        viewModel.didSelectRow(at: IndexPath(row: 1, section: 0)) // expand university in first province cell
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 2) // first call expand second call collapse
        XCTAssertEqual(view.invokedReloadSectionsCount, 2) // first call expand second call collapse
        XCTAssertEqual(view.invokedReloadRowsParametersList.map { $0.indexPaths }, [[IndexPath(row: 1, section: 0)],[IndexPath(row: 0, section: 0)]])
        XCTAssertEqual(view.invokedReloadSectionsParametersList.map { $0.indexSet }, [IndexSet(integer: 0),IndexSet(integer: 0)])
        
    }
    
    func test_didScrollToTopButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedScrollToTop)
        
        
        // When
        viewModel.didScrollToTopButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedScrollToTopCount, 1)
        
    }
    
}
