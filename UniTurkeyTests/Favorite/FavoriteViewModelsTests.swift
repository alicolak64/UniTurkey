//
//  FavoriteViewModelsTests.swift
//  FavoriteViewModelTests
//
//  Created by Ali Çolak on 28.04.2024.
//

import XCTest
@testable import UniTurkey

final class FavoriteViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var view: MockFavoriteViewController!
    private var viewModel: FavoriteViewModel!
    private var favoriteService: MockFavoriteManager!
    private var router: MockFavoriteRouter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favoriteService = MockFavoriteManager()
        router = MockFavoriteRouter()
        viewModel = FavoriteViewModel(router: router,
                                      favoriteService: favoriteService)
        view = MockFavoriteViewController()
        viewModel.delegate = view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        viewModel = nil
        favoriteService = nil
        router = nil
    }
    
    func prepareViewModel() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let provinceResponse = MockProvincePages.page1.provinces.first!
        let universityResponse = provinceResponse.universities.first!
        let university = University(university: universityResponse, provinceId: provinceResponse.id, index: indexPath.row)
        let indexPath2 = IndexPath(row: 0, section: 0)
        let universityResponse2 = provinceResponse.universities[1]
        let university2 = University(university: universityResponse2, provinceId: provinceResponse.id, index: indexPath2.row)
        university.toggleFavorite()
        university2.toggleFavorite()
        favoriteService.addFavorite(university)
        favoriteService.addFavorite(university2)
        
        viewModel.viewDidLoad()
        viewModel.viewDidLayoutSubviews()
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenFavoriteListFill() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedReloadTableView)
        XCTAssertFalse(view.invokedHideEmptyState)
        XCTAssertFalse(view.invokedShowEmptyState)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let provinceResponse = MockProvincePages.page1.provinces.first!
        let universityResponse = provinceResponse.universities.first!
        let university = University(university: universityResponse, provinceId: provinceResponse.id, index: indexPath.row)
        favoriteService.addFavorite(university)
        
        // When
        
        viewModel.viewDidLoad()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedReloadTableViewCount, 1)
        XCTAssertEqual(view.invokedHideEmptyStateCount, 1)
        XCTAssertEqual(view.invokedShowEmptyStateCount, 0)
        XCTAssertEqual(viewModel.numberOfRowsInSection(at: 0), 1)
        
        XCTAssertEqual(view.invokedPrepareNavigationBarParametersList.map( { $0.title }), [Constants.Text.favoritesTitle])
        
    }
    
    func test_viewDidLoad_InvokesRequiredMethods_whenFavoriteListEmpty() {
        
        // Given
        XCTAssertFalse(view.invokedPrepareTableView)
        XCTAssertFalse(view.invokedPrepareNavigationBar)
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedReloadTableView)
        XCTAssertFalse(view.invokedHideEmptyState)
        XCTAssertFalse(view.invokedShowEmptyState)
        
        // When
        
        viewModel.viewDidLoad()
        
        // Then
        
        XCTAssertEqual(view.invokedPrepareTableViewCount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarCount, 1)
        XCTAssertEqual(view.invokedPrepareUICount, 1)
        XCTAssertEqual(view.invokedPrepareNavigationBarParametersList.map( { $0.title }), [Constants.Text.favoritesTitle])
        
        
        let expectation = XCTestExpectation(description: "ShowEmptyState")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let view = self?.view else { return }
            XCTAssertEqual(view.invokedReloadTableViewCount, 0)
            XCTAssertEqual(view.invokedHideEmptyStateCount, 0)
            XCTAssertEqual(view.invokedShowEmptyStateCount, 1)
            XCTAssertEqual(self?.viewModel.numberOfRowsInSection(at: 0), 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
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
        
        viewModel.backButtonTapped()
        
        // Then
        
        XCTAssertEqual(router.invokedNavigateCount, 1)
        XCTAssertTrue(router.invokedNavigateParametersList.isEmpty)
        
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
        
        // Then
        XCTAssertEqual(favoriteService.isFavorite(university), false)
        
    }
    
    func test_didSelectShare_InvokesRequiredMethods_whenShareAllDetail() {
        
        // Given
        XCTAssertFalse(view.invokedShareDetail)
        
        let universityIndexPath = IndexPath(row: 0, section: 0) // first university ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
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
        
        let universityIndexPath = IndexPath(row: 0, section: 0) // first university ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
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
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenUniversitiesNonExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        
        prepareViewModel()
        
        // When
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 0)
        
    }
    
    func test_didScaleDownButtonTapped_InvokesRequiredMethods_whenUniversitiesExpanded() {
        
        // Given
        XCTAssertFalse(view.invokedReloadRows)
        
        let firstUniversityIndexPath = IndexPath(row: 0, section: 0) // first university ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
        let secondUniversityIndexPath = IndexPath(row: 1, section: 0) // second university ÇUKUROVA ÜNİVERSİTESİ
        
        prepareViewModel()
        
        // When
        viewModel.didSelectRow(at: firstUniversityIndexPath)
        viewModel.didSelectRow(at: secondUniversityIndexPath)
        viewModel.didScaleDownButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 3) // first and second call expand third call scale down
        XCTAssertEqual(view.invokedReloadRowsParametersList.map { $0.indexPaths }, [[firstUniversityIndexPath],[secondUniversityIndexPath],[firstUniversityIndexPath,secondUniversityIndexPath]])
        
    }
    
    func test_didTrashButtonTapped_InvokesRequiredMethods_whenFavoriteListEmpty() {
        
        // Given
        XCTAssertFalse(view.invokedShowAlert)
        
        // When
        viewModel.didTrashButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedShowAlertCount, 1)
        XCTAssertEqual(view.invokedShowAlertParametersList.map{ $0.alertMessage.title } , [Constants.Text.warningNoFavoriteTitle])
        XCTAssertEqual(view.invokedShowAlertParametersList.map{ $0.alertMessage.message } , [Constants.Text.warningNoFavoriteMessage])
        XCTAssertFalse(view.invokedDeleteRows)
        
    }
    
    func test_didTrashButtonTapped_InvokesRequiredMethods_withActionSheetSuccess_whenFavoriteListFill() {
        
        // Given
        XCTAssertFalse(view.invokedShowActionSheet)
        XCTAssertFalse(view.invokedDeleteRows)
        XCTAssertFalse(view.invokedShowEmptyState)
        
        prepareViewModel()
        
        XCTAssertEqual(favoriteService.getFavorites().count, 2)
        
        
        // When
        view.invokedShowActionSheetSuccess = true
        viewModel.didTrashButtonTapped()
        
        // Then
        XCTAssertEqual(view.invokedShowActionSheetCount, 1)
        XCTAssertEqual(view.invokedShowActionSheetParametersList.map{ $0.alertMessage.title } , [Constants.Text.warningRemoveAllTitle])
        XCTAssertEqual(view.invokedShowActionSheetParametersList.map{ $0.alertMessage.message } , [Constants.Text.warningRemoveAllMessage])
        XCTAssertEqual(view.invokedDeleteRowsCount, 1)
        XCTAssertEqual(view.invokedDeleteRowsParametersList.map{ $0.indexPaths }, [[IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]])
        XCTAssertTrue(favoriteService.getFavorites().isEmpty)
        
        let expectation = XCTestExpectation(description: "showEmptyState")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let view = self?.view else { return }
            XCTAssertEqual(view.invokedShowEmptyStateCount, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    func test_didTrashButtonTapped_InvokesRequiredMethods_withActionSheetCancel_whenFavoriteListFill() {
        
        // Given
        XCTAssertFalse(view.invokedShowActionSheet)
        XCTAssertFalse(view.invokedDeleteRows)
        XCTAssertFalse(view.invokedShowEmptyState)
        
        prepareViewModel()
        
        // When
        viewModel.didTrashButtonTapped()
        
        // Then
        
        XCTAssertEqual(view.invokedShowActionSheetCount, 1)
        XCTAssertEqual(view.invokedShowActionSheetParametersList.map{ $0.alertMessage.title } , [Constants.Text.warningRemoveAllTitle])
        XCTAssertEqual(view.invokedShowActionSheetParametersList.map{ $0.alertMessage.message } , [Constants.Text.warningRemoveAllMessage])
        XCTAssertEqual(view.invokedDeleteRowsCount, 0)
        XCTAssertEqual(favoriteService.getFavorites().count, 2)
        XCTAssertEqual(view.invokedShowEmptyStateCount, 0)
        
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
    
    func test_numberOfRowsInSection_ReturnsCorrectValue() {
        
        // Given
        
        prepareViewModel()
        
        // When
        let numberOfRows = viewModel.numberOfRowsInSection(at: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, 2)
        
    }
    
    func test_cellForRowAtIndex_withFirstCell_ReturnsCorrectValue() {
        
        // Given
        
        let university1 = MockProvincePages.province1.universities[0] // ADALET BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ
        let indexPath = IndexPath(row: 0, section: 0)
        
        prepareViewModel()
        
        // When
        let cell = viewModel.cellForRow(at: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertEqual(cell?.universityName, university1.name.apiCapitaledTrimmed)
        XCTAssertEqual(cell?.expansionIconState, .plus)
        XCTAssertEqual(cell?.favoriteIconState, .filled)
        XCTAssertEqual(cell?.isFavorite, true)
        XCTAssertEqual(cell?.indexPath, indexPath)
        XCTAssertEqual(cell?.details.count, 6)
        XCTAssertEqual(cell?.details[0].value, university1.phone)
        XCTAssertEqual(cell?.details[1].value, university1.fax)
        XCTAssertEqual(cell?.details[2].value, university1.website)
        XCTAssertEqual(cell?.details[3].value, university1.email)
        XCTAssertEqual(cell?.details[4].value, university1.address.apiTrimmed)
        XCTAssertEqual(cell?.details[5].value, university1.rector.apiCapitaledTrimmed)
        
    }
    
    func test_cellForRowAtIndex_withLastCell_ReturnsCorrectValue() {
        
        // Given
        
        let university2 = MockProvincePages.province1.universities[1] // ÇUKUROVA ÜNİVERSİTESİ
        let indexPath = IndexPath(row: 1, section: 0)
        
        prepareViewModel()
        
        // When
        let cell = viewModel.cellForRow(at: IndexPath(row: 1, section: 0))
        
        // Then
        XCTAssertEqual(cell?.universityName, university2.name.apiCapitaledTrimmed)
        XCTAssertEqual(cell?.expansionIconState, .plus)
        XCTAssertEqual(cell?.favoriteIconState, .filled)
        XCTAssertEqual(cell?.isFavorite, true)
        XCTAssertEqual(cell?.indexPath, indexPath)
        XCTAssertEqual(cell?.details.count, 6)
        XCTAssertEqual(cell?.details[0].value, university2.phone)
        XCTAssertEqual(cell?.details[1].value, university2.fax)
        XCTAssertEqual(cell?.details[2].value, university2.website)
        XCTAssertEqual(cell?.details[3].value, university2.email)
        XCTAssertEqual(cell?.details[4].value, university2.address.apiTrimmed)
        XCTAssertEqual(cell?.details[5].value, university2.rector.apiCapitaledTrimmed)
        
    }
    
    func test_didSelectRow_withExpand_InvokesRequiredMethods() {
        
        // Given
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        prepareViewModel()
        
        XCTAssertEqual(viewModel.cellForRow(at: indexPath)?.expansionIconState, .plus)
        
        // When
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 1)
        XCTAssertEqual(view.invokedReloadRowsParametersList.map{ $0.indexPaths }, [[indexPath]])
        
        XCTAssertEqual(viewModel.cellForRow(at: indexPath)?.expansionIconState, .minus)
        
    }
    
    func test_didSelectRow_withExpandAndCollapse_InvokesRequiredMethods() {
        
        // Given
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        prepareViewModel()
        
        XCTAssertEqual(viewModel.cellForRow(at: indexPath)?.expansionIconState, .plus)
        
        // When
        viewModel.didSelectRow(at: indexPath)
        viewModel.didSelectRow(at: indexPath)
        
        // Then
        XCTAssertEqual(view.invokedReloadRowsCount, 2)
        XCTAssertEqual(view.invokedReloadRowsParametersList.map{ $0.indexPaths }, [[indexPath], [indexPath]])
        
        XCTAssertEqual(viewModel.cellForRow(at: indexPath)?.expansionIconState, .plus)
        
    }
    
    func test_heightForRow_withCellNonExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = CGFloat(Constants.UI.nonExpandCellHeight)
        let indexPath = IndexPath(row: 0, section: 0)
        
        
        // When
        prepareViewModel()
        
        // Then
        XCTAssertEqual(viewModel.heightForRow(at: indexPath), expectedValue)
        
    }
    
    func test_heightForRow_withCellExpanded_ReturnsCorrectValue() {
        
        // Given
        let expectedValue = CGFloat(Constants.UI.nonExpandCellHeight + (Constants.UI.detailCellHeight * 6))
        let indexPath = IndexPath(row: 0, section: 0)
        
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
        
        // When
        
        viewModel.scrollViewDidScroll(contentOffset: contentOffset)
        
        // Then
        XCTAssertEqual(view.invokedShowScrollToTopButtonCount, 1)
        
    }
    
    func test_scrollViewDidScroll_withRequiredHideScrollToTopButton_InvokesRequiredMethods() {
        
        // Given
        XCTAssertFalse(view.invokedHideScrollToTopButton)
        let contentOffset = CGPoint(x: 0, y: 0)
        
        // When
        viewModel.scrollViewDidScroll(contentOffset: contentOffset)
        
        // Then
        XCTAssertEqual(view.invokedHideScrollToTopButtonCount, 1)
        
    }
    
    
}
