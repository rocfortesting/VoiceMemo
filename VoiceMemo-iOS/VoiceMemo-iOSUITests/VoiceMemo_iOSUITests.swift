//
//  VoiceMemo_iOSUITests.swift
//  VoiceMemo-iOSUITests
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import XCTest

class VoiceMemo_iOSUITests: XCTestCase {
        
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
    
    func testUnderAlreadyGotPermissionCase () {
        let app = XCUIApplication()
        let element2 = app.otherElements.containing(.navigationBar, identifier:"Voice Memo").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let element = element2.children(matching: .other).element
        element.tap()
        
        let alert = app.alerts["是否保存？"]
        let button = alert.buttons["是"]
        button.tap()
        element2.children(matching: .other).element(boundBy: 0).tap()
        alert.buttons["否"].tap()
        element.tap()
        button.tap()
        element2.children(matching: .other).element(boundBy: 1).tap()
        app.navigationBars["Voice Memo"].buttons["列表"].tap()
        app.navigationBars.buttons["Voice Memo"].tap()
    }
    
}
