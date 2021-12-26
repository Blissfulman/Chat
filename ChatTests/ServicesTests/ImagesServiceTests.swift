//
//  ImagesServiceTests.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat
import XCTest

final class ImagesServiceTests: XCTestCase {
    
    // MARK: - Nested types
    
    struct ImagesResponseParser: APIParser {
        typealias Model = ImagesResponse
    }
    
    enum TestError: Error {
        case emptyError
    }
    
    // MARK: - Private properties
    
    private var apiRequestSender = APIRequestSenderMock()
    private var imagesService: ImagesService?
    
    // MARK: - Lifecycle methods
    
    override func setUp() {
        super.setUp()
        imagesService = ImagesServiceImpl(apiRequestSender: apiRequestSender)
    }

    override func tearDown() {
        imagesService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchImagesSuccess() {
        let expectation = XCTestExpectation()
        let response = ImagesResponse(totalItems: 10, imageItems: [])
        apiRequestSender.result = .success(response)
        var isSuccess = false
        
        imagesService?.fetchImages(query: "test", itemsPerPage: 10, page: 1) { result in
            if case .success = result {
                isSuccess = true
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isSuccess)
    }
    
    func testFetchImagesFailure() {
        let expectation = XCTestExpectation()
        apiRequestSender.result = .failure(TestError.emptyError)
        var isFailure = false
        
        imagesService?.fetchImages(query: "test", itemsPerPage: 10, page: 1) { result in
            if case .failure = result {
                isFailure = true
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isFailure)
    }
}
