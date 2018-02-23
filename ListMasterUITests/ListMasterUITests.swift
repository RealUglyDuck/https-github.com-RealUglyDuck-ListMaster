//
//  ListMasterUITests.swift
//  ListMasterUITests
//
//  Created by Paweł Ambrożej on 22/02/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import XCTest

class ListMasterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        XCUIApplication().buttons["AddButton"].tap()
        
        let listNameTextField = app.textFields["List name..."]
        listNameTextField.typeText("Morri")
        app.typeText("sons")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).tap()
        app.tables["Empty list"].tap()
        app.buttons["AddButton"].tap()
        listNameTextField.typeText("Tom")
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tomatoes\r"]/*[[".cells.staticTexts[\"Tomatoes\\r\"]",".staticTexts[\"Tomatoes\\r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["kg"].tap()
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        listNameTextField.tap()
        listNameTextField.typeText("Potatoes")
        
        let element5 = element.children(matching: .other).element(boundBy: 1)
        let element4 = element5.children(matching: .other).element
        let element2 = element4.children(matching: .other).element(boundBy: 1)
        element2.tap()
        
        let kgStaticText = element5.staticTexts["kg"]
        kgStaticText.tap()
        addButton.tap()
        listNameTextField.tap()
        listNameTextField.typeText("Carr")
        app.typeText("ot")
        element2.tap()
        kgStaticText.tap()
        addButton.tap()
        element4.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        tablesQuery2.cells.containing(.staticText, identifier:"Tomatoes ").staticTexts["kg"].swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Carrots "]/*[[".cells.staticTexts[\"Carrots \"]",".staticTexts[\"Carrots \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element3 = element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element3.tap()
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["22/02/2018"]/*[[".cells.staticTexts[\"22\/02\/2018\"]",".staticTexts[\"22\/02\/2018\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.swipeLeft()
        
    }
    
}
