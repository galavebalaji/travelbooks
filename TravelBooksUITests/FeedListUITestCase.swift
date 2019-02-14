//
//  BaseUITestCase.swift
//  TravelBooksUITests

import XCTest

class FeedListUITestCase: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFriendsButton() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let sortByLabel = app.staticTexts["Sort By"]
        XCTAssertTrue(sortByLabel.exists)
        app.buttons["Friends"].tap()
        XCTAssertFalse(sortByLabel.exists)
    }
    
    func testTravelBooksButton() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let buttonFriends = app.buttons["Friends"]
        let buttonCommunity = app.buttons["Community"]
        let buttonTravelBooks = app.buttons["TravelBooks"]
        let sortByLabel = app.staticTexts["Sort By"]
        
        XCTAssertTrue(buttonFriends.exists)
        XCTAssertTrue(buttonCommunity.exists)
        XCTAssertTrue(sortByLabel.exists)
        
        buttonTravelBooks.tap()
        
        XCTAssertFalse(buttonFriends.exists)
        XCTAssertFalse(buttonCommunity.exists)
        XCTAssertFalse(sortByLabel.exists)
        
    }

}
