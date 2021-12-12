//
//  SettingsServiceTests.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 09.12.2021.
//

@testable import Chat
import XCTest

final class SettingsServiceTests: XCTestCase {
    
    // MARK: - Private properties
    
    private var settingsManager: SettingsManager?
    private var settingsService: SettingsService?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        settingsManager = SettingsManagerMock()
        if let settingsManager = settingsManager {
            settingsService = SettingsServiceImpl(settingsManager: settingsManager, asyncHandler: AsyncHandlerMock())
        }
    }

    override func tearDown() {
        settingsManager = nil
        settingsService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSavingTheme() {
        settingsManager?.theme = .champagne
        settingsService?.saveTheme(.dark)
        XCTAssertEqual(settingsManager?.theme, .dark)
    }
    
    func testGettingTheme() {
        settingsManager?.theme = .champagne
        let expectation = XCTestExpectation()
        var theme: Theme?
        settingsService?.getTheme { value in
            theme = value
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(theme, .champagne)
    }
}
