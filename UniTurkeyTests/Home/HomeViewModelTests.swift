//
//  UniTurkeyTests.swift
//  HomeViewModelTests
//
//  Created by Ali Çolak on 7.04.2024.
//

import XCTest
@testable import UniTurkey

final class HomeViewModelTests: XCTestCase {
    
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
    
    func prepareViewModel() {
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        viewModel.viewDidLayoutSubviews()
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenAPISuccess() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedStopLoading)
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        viewModel.viewDidLoad()
        
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedStartLoadingCount, 1)
        XCTAssertEqual(view.invokedStopLoadingCount, 1)
        XCTAssertEqual(view.invokedReloadTableViewCount, 1)
        
        XCTAssertEqual( view.invokedPrepareNavigationBarParametersList.map( { $0.title } ), [Constants.Text.homeTitle] )
        
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenAPIFailure() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedStopLoading)
        
        let errorDescription = ServiceError.noDataError.localizedDescription
        
        // When
        universityService.completionCase = .noDataError
        prepareViewModel()
        
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
            XCTAssertEqual(view.invokedShowErrorParametersList.map({ $0.error.localizedDescription }), [errorDescription])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        
    }
    
    func test_viewWillAppear_InvokesRequiredMethods_whenAPISuccess() {
        
        // Given
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(view.invokedReloadTableViewCount, 2)
        
    }
    
    func test_viewWillAppear_InvokesRequiredMethods_whenAPIFailure() {
        
        // Given
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        universityService.completionCase = .noConnectionError
        prepareViewModel()
        
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
        
        prepareViewModel()
        
        // When
        viewModel.didFavoriteButtonTapped()
        
        // Then
        XCTAssertEqual(router.invokedNavigateCount, 1)
        XCTAssertTrue(router.invokedNavigateParametersList.isEmpty)
        
    }
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenProvinceNonExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        XCTAssertFalse(view.invokedReloadSections)
        
        prepareViewModel()
        
        // When
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 0)
        XCTAssertEqual(view.invokedReloadSectionsCount, 0)
        
    }
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenProvinceExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        XCTAssertFalse(view.invokedReloadSections)
        
        let provinceIndexPath = IndexPath(row: 0, section: 0) // expand province in first cell (Adana)
        let universityIndexPath = IndexPath(row: 1, section: 0) // expand university in first province cell (ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: provinceIndexPath)
        viewModel.didSelectRow(at: universityIndexPath)
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 2) // first call expand second call collapse
        XCTAssertEqual(view.invokedReloadSectionsCount, 2) // first call expand second call collapse
        XCTAssertEqual(view.invokedReloadRowsParametersList.map { $0.indexPaths }, [[universityIndexPath],[universityIndexPath]])
        XCTAssertEqual(view.invokedReloadSectionsParametersList.map { $0.indexSet }, [IndexSet(integer: provinceIndexPath.section),IndexSet(integer: provinceIndexPath.section)])
        
    }
    
    func test_didScrollToTopButtonTapped_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedScrollToTop)
        
        prepareViewModel()
        
        // When
        viewModel.didScrollToTopButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedScrollToTopCount, 1)
        
    }
    
    func test_didSelectShare_InvokesRequiredMethods_whenShareAllDetail() {
        
        // Given
        XCTAssertFalse(view.invokedShareDetail)
        
        let universityIndexPath = IndexPath(row: 1, section: 0) // first university ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
        let callIndexPath = IndexPath(row: 0, section: 0) // first university first detail (phone)
        let faxIndexPath = IndexPath(row: 1, section: 0) // first university first detail (fax)
        let websiteIndexPath = IndexPath(row: 2, section: 0) // first university first detail (website)
        let emailIndexPath = IndexPath(row: 3, section: 0) // first university first detail (email)
        let addressIndexPath = IndexPath(row: 4, section: 0) // first university first detail (address)
        let rectorIndexPath = IndexPath(row: 5, section: 0) // first university first detail (rector)
        
        let university = MockProvincePages.province1.universities[0]
        
        prepareViewModel()
        
        // When
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: callIndexPath)
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: faxIndexPath)
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: websiteIndexPath)
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: emailIndexPath)
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: addressIndexPath)
        viewModel.didSelectShare(universityIndexPath: universityIndexPath, detailIndexPath: rectorIndexPath)
        
        
        // Then
        XCTAssertEqual(view.invokedShareDetailCount, 6)
        XCTAssertEqual(view.invokedShareDetailParametersList.map{ $0.text } , [
            university.phone,
            university.fax,
            university.website,
            university.email,
            university.address,
            university.rector.apiCapitaledTrimmed
        ])
        
    }
    
    func test_didSelectDetail_InvokesRequiredMethods_whenSelectAllDetail() {
        
        // Given
        XCTAssertFalse(view.invokedCallPhone)
        XCTAssertFalse(view.invokedShowAlert)
        XCTAssertFalse(view.invokedSendEmail)
        XCTAssertFalse(view.invokedOpenMapAddress)
        XCTAssertFalse(view.invokedSearchTextSafari)
        XCTAssertFalse(router.invokedNavigate)
        
        let universityIndexPath = IndexPath(row: 1, section: 0) // first university ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
        let callIndexPath = IndexPath(row: 0, section: 0) // first university first detail (phone)
        let faxIndexPath = IndexPath(row: 1, section: 0) // first university first detail (fax)
        let websiteIndexPath = IndexPath(row: 2, section: 0) // first university first detail (website)
        let emailIndexPath = IndexPath(row: 3, section: 0) // first university first detail (email)
        let addressIndexPath = IndexPath(row: 4, section: 0) // first university first detail (address)
        let rectorIndexPath = IndexPath(row: 5, section: 0) // first university first detail (rector)
        
        let university = MockProvincePages.province1.universities[0]
        
        prepareViewModel()
        
        // When
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: callIndexPath)
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: faxIndexPath)
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: websiteIndexPath)
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: emailIndexPath)
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: addressIndexPath)
        viewModel.didSelectDetail(universityIndexPath: universityIndexPath, detailIndexPath: rectorIndexPath)
        
        // Then
        
        XCTAssertEqual(view.invokedCallPhoneCount, 1)
        XCTAssertEqual(view.invokedShowAlertCount, 1)
        XCTAssertEqual(view.invokedSendEmailCount, 1)
        XCTAssertEqual(view.invokedOpenMapAddressCount, 1)
        XCTAssertEqual(view.invokedSearchTextSafariCount, 1)
        XCTAssertEqual(router.invokedNavigateCount, 1)
        
        XCTAssertEqual(view.invokedCallPhoneParametersList.map{ $0.with } , [university.phone])
        XCTAssertEqual(view.invokedShowAlertParametersList.map{ $0.alertMessage.message } , [university.fax])
        XCTAssertEqual(view.invokedSendEmailParametersList.map{ $0.with } , [university.email])
        XCTAssertEqual(view.invokedOpenMapAddressParametersList.map{ $0.with } , [university.address])
        XCTAssertEqual(view.invokedSearchTextSafariParametersList.map{ $0.with } , [university.rector.apiCapitaledTrimmed])
        XCTAssertEqual(router.invokedNavigateParametersList.map{ $0.name } , [university.name.apiCapitaledTrimmed])
        XCTAssertEqual(router.invokedNavigateParametersList.map{ $0.url } , [university.website])
        
    }
    
    func test_didRertyButtonTapped_InvokesRequiredMethods_whenApiSuccess() {
        
        // Given
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedStopLoading)
        XCTAssertFalse(view.invokedReloadTableView)
        
        // When
        viewModel.didRertyButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedStartLoadingCount, 1)
        XCTAssertEqual(view.invokedStopLoadingCount, 2)
        XCTAssertEqual(view.invokedReloadTableViewCount, 1)
        
    }
    
    func test_didRertyButtonTapped_InvokesRequiredMethods_whenApiFailure() {
        
        // Given
        XCTAssertFalse(view.invokedStartLoading)
        XCTAssertFalse(view.invokedStopLoading)
        XCTAssertFalse(view.invokedReloadTableView)
        XCTAssertFalse(view.invokedShowError)
        
        let errorDescription = ServiceError.noConnectionError.localizedDescription
        
        // When
        universityService.completionCase = .noConnectionError
        viewModel.didRertyButtonTapped()
        
        // Then
        
        XCTAssertEqual(view.invokedStartLoadingCount, 1)
        XCTAssertEqual(view.invokedReloadTableViewCount, 0)
        
        let expectation = XCTestExpectation(description: "ViewDidLoad completed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak view] in
            guard let view = view else { XCTFail("View is nil"); return }
            XCTAssertEqual(view.invokedShowErrorCount, 1)
            XCTAssertEqual(view.invokedStopLoadingCount, 2)
            XCTAssertEqual(view.invokedShowErrorParametersList.map({ $0.error.localizedDescription }), [errorDescription])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
    }
    
    func test_numberOfSections_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = MockProvincePages.page1Provinces.count
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.numberOfSections(), expectedValue)
        
    }
    
    func test_numberOfRowsInSection_withExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = MockProvincePages.page1Provinces[0].universities.count + 1
        let indexPath = IndexPath(row: 0, section: 0)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(viewModel.numberOfRowsInSection(at: indexPath.section),expectedValue)
    }
    
    func test_numberOfRowsInSection_withNonExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = 1
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.numberOfRowsInSection(at: indexPath.section),expectedValue)
        
    }
    
    func test_cellForRow_withSection_ReturnsCorrectValue() {
        
        // Given
        let expectedValueForProvince = MockProvincePages.page1Provinces[0].province.apiCapitaledTrimmed
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.cellForRow(at: indexPath.section)?.provinceName, expectedValueForProvince)
        
    }
    
    func test_cellForRow_withCell_ReturnsCorrectValue() {
        
        // Given
        let expectedValueForUniversity = MockProvincePages.province1.universities[0].name.apiCapitaledTrimmed
        let indexPath = IndexPath(row: 1, section: 0)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.cellForRow(at: indexPath)?.universityName, expectedValueForUniversity)
        
    }
    
    func test_didSelectRow_withSection_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedReloadSections)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(view.invokedReloadSectionsCount, 1)
        XCTAssertEqual(view.invokedReloadSectionsParametersList.map{ $0.indexSet }, [IndexSet(integer: indexPath.section)])
        
    }
    
    func test_didSelectRow_withCell_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 1)
        XCTAssertEqual(view.invokedReloadRowsParametersList.map{ $0.indexPaths }, [[indexPath]])
        
    }
    
    func test_heightForRow_withSection_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = CGFloat(Constants.UI.nonExpandCellHeight)
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.heightForRow(at: indexPath), expectedValue)
        
    }
    
    func test_heightForRow_withCellNonExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = CGFloat(Constants.UI.nonExpandCellHeight)
        let indexPath = IndexPath(row: 1, section: 0)
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.heightForRow(at: indexPath), expectedValue)
        
    }
    
    func test_heightForRow_withCellExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = CGFloat(Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * 6))
        let indexPath = IndexPath(row: 1, section: 0)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(viewModel.heightForRow(at: indexPath), expectedValue)
        
    }
    
    func test_scrollViewDidScroll_withRequiredShowScrollToTopButton_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedShowScrollToTopButton)
        let contentOffset = CGPoint(x: 0, y: 101)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        
        // When
        
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        // Then
        XCTAssertEqual(view.invokedShowScrollToTopButtonCount, 1)
        
    }
    
    func test_scrollViewDidScroll_withRequiredHideScrollToTopButton_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedHideScrollToTopButton)
        let contentOffset = CGPoint(x: 0, y: 0)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        // When
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        // Then
        XCTAssertEqual(view.invokedHideScrollToTopButtonCount, 1)
        
    }
    
    func test_scrollViewDidScroll_NonRequiredPagination_withScrollValue_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset = CGPoint(x: 0, y: 0)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        let provinceCount = MockProvincePages.page1Provinces.count
        
        prepareViewModel()
        
        // When
        
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        // Then
        
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 0)
        XCTAssertEqual(view.invokedStopPaginationLoadingCount, 0)
        XCTAssertEqual(view.invokedShowErrorCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 2) // first call viewDidLoad, second call viewWillAppear no call pagination
        XCTAssertEqual(viewModel.numberOfSections(), provinceCount)
        
    }
    
    func test_scrollViewDidScroll_NonRequiredPagination_withLimitSecond_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset = CGPoint(x: 0, y: 100)
        let contentOffset2 = CGPoint(x: 0, y: 200)
        let contentSize = CGSize(width: 0, height: 200)
        let contentSize2 = CGSize(width: 0, height: 300)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        let bounds2 = CGRect(x: 0, y: 0, width: 0, height: 200)
        
        let provinceCount = MockProvincePages.page1Provinces.count + MockProvincePages.page2Provinces.count
        
        prepareViewModel()
        
        // When
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        viewModel.scrollViewDidScroll(contentOffset: contentOffset2, contentSize: contentSize2, bounds: bounds2)
        
        
        // Then
        
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 1)
        XCTAssertEqual(view.invokedStopPaginationLoadingCount, 1)
        XCTAssertEqual(view.invokedShowErrorCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 3) // first call viewDidLoad, second call viewWillAppear no call pagination
        XCTAssertEqual(viewModel.numberOfSections(), provinceCount)
        
    }
    
    func test_scrollViewDidScroll_RequiredPagination_withScrollValue_InvokesRequiredMethods_whenApiSuccess() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset = CGPoint(x: 0, y: 100)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        let provinceCount = MockProvincePages.page1Provinces.count + MockProvincePages.page2Provinces.count
        
        prepareViewModel()
        
        // When
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        // Then
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 1)
        XCTAssertEqual(view.invokedStopPaginationLoadingCount, 1)
        XCTAssertEqual(view.invokedShowErrorCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 3) // first call viewDidLoad, second call viewWillAppear, third call pagination
        XCTAssertEqual(viewModel.numberOfSections(), provinceCount)
        
    }
    
    func test_scrollViewDidScroll_RequiredPagination_withLimitSecond_InvokesRequiredMethods_whenApiSuccess() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset = CGPoint(x: 0, y: 100)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        let limit = Constants.UI.infinityScrollLateLimitSecond + 0.5
        
        let provinceCount = MockProvincePages.page1Provinces.count + MockProvincePages.page2Provinces.count + MockProvincePages.page3Provinces.count
        
        prepareViewModel()
        
        // When
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        let expectation = XCTestExpectation(description: "Scroll view did scroll")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + limit) { [weak self] in
            self?.viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: limit + 0.5)
        
        // Then
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 2)
        XCTAssertEqual(view.invokedStopPaginationLoadingCount, 2)
        XCTAssertEqual(view.invokedShowErrorCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 4) // first call viewDidLoad, second call viewWillAppear, third call pagination
        XCTAssertEqual(viewModel.numberOfSections(), provinceCount)
        
    }
    
    func test_scrollViewDidScroll_withRequiredPagination_InvokesRequiredMethods_whenApiFailure() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset = CGPoint(x: 0, y: 100)
        let contentSize = CGSize(width: 0, height: 200)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        
        let errorDescription = ServiceError.noConnectionError.localizedDescription
        
        let provinceCount = MockProvincePages.page1Provinces.count
        
        prepareViewModel()
        
        // When
        universityService.completionCase = .noConnectionError
        viewModel.scrollViewDidScroll(contentOffset: contentOffset, contentSize: contentSize, bounds: bounds)
        
        // Then
        
        let expectation = XCTestExpectation(description: "ViewDidLoad completed")
        
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 1)
        XCTAssertEqual(view.invokedReloadTableViewCount, 2) // first call viewDidLoad, second call viewWillAppear but no call pagination
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { XCTFail("Self is nil"); return }
            guard let view = self.view else { XCTFail("View is nil"); return }
            XCTAssertEqual(view.invokedShowErrorCount, 1)
            XCTAssertEqual(view.invokedStopPaginationLoadingCount, 1)
            XCTAssertEqual(view.invokedShowErrorParametersList.map({ $0.error.localizedDescription }), [errorDescription])
            XCTAssertEqual(view.invokedReloadTableViewCount, 2) // first call viewDidLoad, second call viewWillAppear but no call pagination
            XCTAssertEqual(self.viewModel.numberOfSections(), provinceCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
    }
    
    func test_scrollViewDidScroll_withNoMoreData_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedStartPaginationLoading)
        XCTAssertFalse(view.invokedStopPaginationLoading)
        XCTAssertFalse(view.invokedShowError)
        XCTAssertFalse(view.invokedReloadTableView)
        
        let contentOffset1 = CGPoint(x: 0, y: 100)
        let contentOffset2 = CGPoint(x: 0, y: 200)
        let contentOffset3 = CGPoint(x: 0, y: 300)
        let contentSize = CGSize(width: 0, height: 200)
        let contentSize2 = CGSize(width: 0, height: 300)
        let contentSize3 = CGSize(width: 0, height: 400)
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        let bounds2 = CGRect(x: 0, y: 0, width: 0, height: 200)
        let bounds3 = CGRect(x: 0, y: 0, width: 0, height: 300)
        
        let limit = Constants.UI.infinityScrollLateLimitSecond + 0.1
        
        let provincesCount = MockProvincePages.page3.totalProvinces
        
        prepareViewModel()
        
        // When
        
        viewModel.scrollViewDidScroll(contentOffset: contentOffset1, contentSize: contentSize, bounds: bounds)
        
        let expectation1 = XCTestExpectation(description: "First scroll view did scroll")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + limit) { [weak self] in
            self?.viewModel.scrollViewDidScroll(contentOffset: contentOffset2, contentSize: contentSize2, bounds: bounds2)
            expectation1.fulfill()
        }
        
        wait(for: [expectation1], timeout: limit + 0.5)
        
        let expectation2 = XCTestExpectation(description: "Second scroll view did scroll")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + limit) { [weak self] in
            self?.viewModel.scrollViewDidScroll(contentOffset: contentOffset3, contentSize: contentSize3, bounds: bounds3)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: limit + 0.5)
        
        // Then
        
        XCTAssertEqual(view.invokedStartPaginationLoadingCount, 2)
        XCTAssertEqual(view.invokedStopPaginationLoadingCount, 2)
        XCTAssertEqual(view.invokedShowErrorCount, 0)
        XCTAssertEqual(view.invokedReloadTableViewCount, 4) // first call viewDidLoad, second call viewWillAppear but no call pagination
        XCTAssertEqual(viewModel.numberOfSections(), provincesCount)
        
    }
    
    func test_didSelectFavorite_withFirstCellFavorite_AddFavorite() {
        
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let provinceResponse = MockProvincePages.page1.provinces.first!
        let universityResponse = provinceResponse.universities.first!
        let university = University(university: universityResponse, provinceId: provinceResponse.id, index: indexPath.row)
        let universityCellViewModel = UniversityCellViewModel(university: university,indexPath: indexPath.indexWithSection)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectFavorite(university: universityCellViewModel)
        
        // Then
        XCTAssertEqual(favoriteService.isFavorite(university), true)
        
    }
    
    func test_didSelectFavorite_withFirstCellFavorite_RemoveFavorite() {
        
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        let provinceResponse = MockProvincePages.page1.provinces.first!
        let universityResponse = provinceResponse.universities.first!
        let university = University(university: universityResponse, provinceId: provinceResponse.id, index: indexPath.row)
        let universityCellViewModel = UniversityCellViewModel(university: university,indexPath: indexPath.indexWithSection)
        
        prepareViewModel()
        
        // When
        viewModel.didSelectFavorite(university: universityCellViewModel)
        viewModel.didSelectFavorite(university: universityCellViewModel)
        
        // Then
        XCTAssertEqual(favoriteService.isFavorite(university), false)
        
    }
    
}
