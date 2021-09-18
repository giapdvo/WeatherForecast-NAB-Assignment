//
//  ForecastSceneUITests.swift
//  weatherforecastUITests
//
//  Created by Giap Vo on 9/18/21.
//

import XCTest

class ForecastSceneUITests: XCTestCase {

    override func setUp() {

        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    // NOTE: for UI tests to work the keyboard of simulator must be on.
    // Keyboard shortcut COMMAND + SHIFT + K while simulator has focus
    private func validateKeyboardShouldShow(app: XCUIElement) {
        if !app.keys["A"].waitForExistence(timeout: 5) {
            XCTFail("The keyboard could not be found. Use keyboard shortcut COMMAND + SHIFT + K while simulator has focus on text input")
        }
    }
    
    private func searchField(with city: String, app: XCUIElement) {
        let searchText = city
        app.searchFields[AccessibilityIdentifier.searchField].tap()
        self.validateKeyboardShouldShow(app: app)
        
        _ = app.searchFields[AccessibilityIdentifier.searchField].waitForExistence(timeout: 10)
        app.searchFields[AccessibilityIdentifier.searchField].typeText(searchText)
        app.buttons["search"].tap()
    }
    
   
    func testSearchSuccess_whenSearchWithCityHanoi_thenTheForecastShouldDisplayOnTheList() {
        let app = XCUIApplication()
        
        self.searchField(with: "Hanoi", app: app)
        
        XCTAssertEqual(app.tables.cells.count , 7)
    }
    
    func testSearchCharacterCondition_whenSearchWithCityWithLessThanThreeCharacter_ThenTheForecastShouldDisplayError() {
        let app = XCUIApplication()
        
        self.searchField(with: "Ha", app: app)
        
        XCTAssertEqual(app.alerts.element.label, "Ops")
        XCTAssert(app.alerts.element.staticTexts["City must be at least 3 character."].exists)
    }
    
    func testSearchUnknowCity_whenSearchWithCityWithUnknowCity_ThenTheForecastShouldDisplayError() {
        let app = XCUIApplication()
        
        self.searchField(with: "Unknown City", app: app)
        
        XCTAssertEqual(app.alerts.element.label, "Ops")
        XCTAssert(app.alerts.element.staticTexts["City not found."].exists)
    }
    
    func testSearchCache_whenTapOnTheSuggestionList_ThenTheForecastShouldDisplayDataOnList() {
        let app = XCUIApplication()
        
        app.searchFields[AccessibilityIdentifier.searchField].tap()
        app.tables.cells.firstMatch.tap()
        
        XCTAssertEqual(app.tables.cells.count , 7)
    }

}
