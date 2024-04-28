//
//  UniTurkeyUITests.swift
//  UniTurkeyUITests
//
//  Created by Ali Çolak on 7.04.2024.
//

import XCTest
@testable import UniTurkey

final class UniTurkeyUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var tableView: XCUIElement!

    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        tableView = app.tables["UniTurkey.HomeView.provincesTableView"]

    
    }

    override func tearDownWithError() throws {
        app = nil
        tableView = nil
    }
    
    func test_navigationTitle() throws {
        let navigationBarTitle = app.staticTexts["UniTurkey.HomeView.navigationTitle"]
        XCTAssertTrue(navigationBarTitle.exists)
        XCTAssertEqual(navigationBarTitle.label, "Universities")
    }
    
    func test_favoriteNavigationBarItem_existings() throws {
        let favoriteButton = app.buttons["UniTurkey.HomeView.favoriteNavigationBarItem"]
        XCTAssertTrue(favoriteButton.exists)
        XCTAssertTrue(favoriteButton.isHittable)
    }
    
    func test_scaleDownNavigationBarItem_existings() throws {
        let scaleDownButton = app.buttons["UniTurkey.HomeView.scaleDownNavigationBarItem"]
        XCTAssertTrue(scaleDownButton.exists)
        XCTAssertTrue(scaleDownButton.isHittable)
    }
    
    func test_provincesTableView_existings() throws {
        XCTAssertTrue(tableView.exists)
    }
    
    func test_expandTableView() throws {
        let province = tableView.cells.element(boundBy: 0)
        let university = tableView.cells.element(boundBy: 1)
        XCTAssertFalse(university.visible())
        province.tap()
        XCTAssertTrue(university.visible())
        university.tap()
    }

}

extension XCUIElement {
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard exists && !frame.isEmpty else {
            return false
        }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
    
    func swipeUp() {
        let start = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        let finish = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        start.press(forDuration: 0, thenDragTo: finish)
    }
    
    func swipeDown() {
        let start = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let finish = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0, thenDragTo: finish)
    }
    
    func tap() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }
    
    
}
