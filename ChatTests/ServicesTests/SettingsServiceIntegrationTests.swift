//
//  SettingsServiceIntegrationTests.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat
import XCTest

final class SettingsServiceIntegrationTests: XCTestCase {
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManagerFake()
    private let keychainStorage = KeychainStorageFake()
    private var settingsService: SettingsService?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        let settingsManager = SettingsManagerImpl(
            fileStorageManager: fileStorageManager,
            keychainStorage: keychainStorage
        )
        settingsService = SettingsServiceImpl(
            settingsManager: settingsManager,
            asyncHandler: GCDAsyncHandler(qos: .userInitiated)
        )
    }
    
    override func tearDown() {
        settingsService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSavingTheme() {
        let expectation = XCTestExpectation()
        fileStorageManager.savedValue = nil
        
        settingsService?.saveTheme(.dark)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(fileStorageManager.savedValue as? Theme, .dark)
    }
    
    func testGettingTheme() {
        let expectation = XCTestExpectation()
        fileStorageManager.savedValue = Theme.champagne
        var theme: Theme?
        
        settingsService?.getTheme { value in
            theme = value
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(theme, .champagne)
    }
}
