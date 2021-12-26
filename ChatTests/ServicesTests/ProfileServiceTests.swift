//
//  ProfileServiceTests.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat
import XCTest

final class ProfileServiceTests: XCTestCase {
    
    // MARK: - Private properties
    
    private var profileDataManager = ProfileDataManagerFake()
    private var profileService: ProfileService?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        profileService = ProfileServiceImpl(profileDataManager: profileDataManager)
    }

    override func tearDown() {
        profileService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSavingProfile() {
        let expectation = XCTestExpectation()
        profileDataManager.savedProfile = nil
        let profile = Profile(fullName: "Name", description: "Hello", avatarData: nil)
        var isSuccess = false
        
        profileService?.saveProfile(profile: profile, asyncHandlerType: .gcd) { result in
            if case .success = result {
                isSuccess = true
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isSuccess)
        let savedProfile = profileDataManager.savedProfile
        XCTAssertEqual(profile.fullName, savedProfile?.fullName)
        XCTAssertEqual(profile.description, savedProfile?.description)
        XCTAssertEqual(profile.avatarData, savedProfile?.avatarData)
    }
    
    func testFetchingProfile() {
        let expectation = XCTestExpectation()
        let savedProfile = Profile(fullName: "Name", description: "Hello", avatarData: nil)
        profileDataManager.savedProfile = savedProfile
        var isSuccess = false
        var fetchedProfile: Profile?
        
        profileService?.fetchProfile { result in
            if case let .success(profile) = result {
                isSuccess = true
                fetchedProfile = profile
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isSuccess)
        XCTAssertEqual(savedProfile.fullName, fetchedProfile?.fullName)
        XCTAssertEqual(savedProfile.description, fetchedProfile?.description)
        XCTAssertEqual(savedProfile.avatarData, fetchedProfile?.avatarData)
    }
}
