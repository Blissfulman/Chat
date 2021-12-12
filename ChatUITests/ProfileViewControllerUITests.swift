//
//  ProfileViewControllerUITests.swift
//  ChatUITests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

import XCTest

final class ProfileViewControllerUITests: XCTestCase {
    
    // MARK: - Private properties
    
    private var app: XCUIApplication?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    // MARK: - Tests
    
    func testProfileTextFieldsEnabled() {
        app?.launch()
        app?.buttons["OpenProfileBarButton"].tap()
        app?.buttons["ProfileEditProfileButton"].tap()
        app?.textFields["ProfileFullNameTextField"].tap()
        app?.textFields["ProfileDescriptionTextField"].tap()
    }
}
