//
//  MockHomeView.swift
//  HomeViewModelTests
//
//  Created by Ali Çolak on 21.04.2024.
//

import Foundation
@testable import UniTurkey

final class MockHomeViewController: HomeViewProtocol {
    
    var invokedPrepareTableView = false
    var invokedPrepareTableViewCount = 0
    
    func prepareTableView() {
        invokedPrepareTableView = true
        invokedPrepareTableViewCount += 1
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
    
    var invokedStartLoading = false
    var invokedStartLoadingCount = 0
    
    func startLoading() {
        invokedStartLoading = true
        invokedStartLoadingCount += 1
    }
    
    var invokedStopLoading = false
    var invokedStopLoadingCount = 0
    
    func stopLoading() {
        invokedStopLoading = true
        invokedStopLoadingCount += 1
    }
    
    var invokedStartPaginationLoading = false
    var invokedStartPaginationLoadingCount = 0
    
    func startPaginationLoading() {
        invokedStartPaginationLoading = true
        invokedStartPaginationLoadingCount += 1
    }
    
    
    var invokedStopPaginationLoading = false
    var invokedStopPaginationLoadingCount = 0
    
    func stopPaginationLoading() {
        invokedStopPaginationLoading = true
        invokedStopPaginationLoadingCount += 1
    }
    
    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (error: Error, Void)?
    var invokedShowErrorParametersList = [(error: Error, Void)]()
    
    func showError(_ error: Error) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (error, ())
        invokedShowErrorParametersList.append((error, ()))
    }
    
    
    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (alertMessage: UniTurkey.AlertMessage, Void)?
    var invokedShowAlertParametersList = [(alertMessage: UniTurkey.AlertMessage, Void)]()
    func showAlert(alertMessage: UniTurkey.AlertMessage) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (alertMessage, ())
        invokedShowAlertParametersList.append((alertMessage, ()))
    }
    
    var invokedShowScrollToTopButton = false
    var invokedShowScrollToTopButtonCount = 0
    
    func showScrollToTopButton() {
        invokedShowScrollToTopButton = true
        invokedShowScrollToTopButtonCount += 1
    }
    
    var invokedHideScrollToTopButton = false
    var invokedHideScrollToTopButtonCount = 0
    
    func hideScrollToTopButton() {
        invokedHideScrollToTopButton = true
        invokedHideScrollToTopButtonCount += 1
    }
    
    var invokedScrollToTop = false
    var invokedScrollToTopCount = 0
    
    func scrollToTop() {
        invokedScrollToTop = true
        invokedScrollToTopCount += 1
    }
    
    var invokedReloadTableView = false
    var invokedReloadTableViewCount = 0
    
    func reloadTableView() {
        invokedReloadTableView = true
        invokedReloadTableViewCount += 1
    }
    
    var invokedReloadSections = false
    var invokedReloadSectionsCount = 0
    var invokedReloadSectionsParameters: (indexSet: IndexSet, Void)?
    var invokedReloadSectionsParametersList = [(indexSet: IndexSet, Void)]()
    
    func reloadSections(at indexSet: IndexSet) {
        invokedReloadSections = true
        invokedReloadSectionsCount += 1
        invokedReloadSectionsParameters = (indexSet, ())
        invokedReloadSectionsParametersList.append((indexSet, ()))
    }
    
    var invokedReloadRows = false
    var invokedReloadRowsCount = 0
    var invokedReloadRowsParameters: (indexPaths: [IndexPath], Void)?
    var invokedReloadRowsParametersList = [(indexPaths: [IndexPath], Void)]()
    
    func reloadRows(at indexPaths: [IndexPath]) {
        invokedReloadRows = true
        invokedReloadRowsCount += 1
        invokedReloadRowsParameters = (indexPaths, ())
        invokedReloadRowsParametersList.append((indexPaths, ()))
    }
    
    var invokedShareDetail = false
    var invokedShareDetailCount = 0
    var invokedShareDetailParameters: (text: String, Void)?
    var invokedShareDetailParametersList = [(text: String, Void)]()
    
    func shareDetail(text: String) {
        invokedShareDetail = true
        invokedShareDetailCount += 1
        invokedShareDetailParameters = (text, ())
        invokedShareDetailParametersList.append((text, ()))
    }
    
    var invokedCallPhone = false
    var invokedCallPhoneCount = 0
    var invokedCallPhoneParameters: (with: String, Void)?
    var invokedCallPhoneParametersList = [(with: String, Void)]()
    
    func callPhone(with: String) {
        invokedCallPhone = true
        invokedCallPhoneCount += 1
        invokedCallPhoneParameters = (with, ())
        invokedCallPhoneParametersList.append((with, ()))
    }
    
    var invokedSendEmail = false
    var invokedSendEmailCount = 0
    var invokedSendEmailParameters: (with: String, Void)?
    var invokedSendEmailParametersList = [(with: String, Void)]()
    
    func sendEmail(with: String) {
        invokedSendEmail = true
        invokedSendEmailCount += 1
        invokedSendEmailParameters = (with, ())
        invokedSendEmailParametersList.append((with, ()))
    }
    
    var invokedOpenMapAddress = false
    var invokedOpenMapAddressCount = 0
    var invokedOpenMapAddressParameters: (with: String, Void)?
    var invokedOpenMapAddressParametersList = [(with: String, Void)]()
    
    func openMapAddress(with: String) {
        invokedOpenMapAddress = true
        invokedOpenMapAddressCount += 1
        invokedOpenMapAddressParameters = (with, ())
        invokedOpenMapAddressParametersList.append((with, ()))
    }
    
    var invokedSearchTextSafari = false
    var invokedSearchTextSafariCount = 0
    var invokedSearchTextSafariParameters: (with: String, Void)?
    var invokedSearchTextSafariParametersList = [(with: String, Void)]()
    
    func searchTextSafari(with: String) {
        invokedSearchTextSafari = true
        invokedSearchTextSafariCount += 1
        invokedSearchTextSafariParameters = (with, ())
        invokedSearchTextSafariParametersList.append((with, ()))
    }
    
    
}

