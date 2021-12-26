//
//  SettingsManagerTests.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat
import XCTest

final class SettingsManagerTests: XCTestCase {
    
    // MARK: - Private properties
    
    private let fileStorageManager = FileStorageManagerFake()
    private let keychainStorage = KeychainStorageFake()
    private var settingsManager: SettingsManager?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        settingsManager = SettingsManagerImpl(fileStorageManager: fileStorageManager, keychainStorage: keychainStorage)
    }

    override func tearDown() {
        settingsManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSavingTheme() {
        fileStorageManager.savedValue = nil
        settingsManager?.theme = .light
        XCTAssertEqual(fileStorageManager.savedValue as? Theme, .light)
    }
    
    func testGettingTheme() {
        fileStorageManager.savedValue = Theme.champagne
        let theme = settingsManager?.theme
        XCTAssertEqual(theme, .champagne)
    }
    
    func testLoadingMySenderIDWhenItIsNotStored() {
        keychainStorage.savedValue = nil
        settingsManager?.loadMySenderID()
        XCTAssertNotNil(GlobalData.mySenderID)
        XCTAssertNotNil(keychainStorage.savedValue)
    }
    
    func testLoadingMySenderIDWhenItIsStored() {
        keychainStorage.savedValue = "E9188508-CB47-4C05-963B-BF14318DC9F1"
        settingsManager?.loadMySenderID()
        XCTAssertEqual(GlobalData.mySenderID, "E9188508-CB47-4C05-963B-BF14318DC9F1")
        XCTAssertEqual(keychainStorage.savedValue, "E9188508-CB47-4C05-963B-BF14318DC9F1")
    }
}
