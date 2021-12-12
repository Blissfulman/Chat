//
//  APIRequestSenderMock.swift
//  ChatTests
//
//  Created by Evgeny Novgorodov on 12.12.2021.
//

@testable import Chat

final class APIRequestSenderMock: APIRequestSender {
    
    // MARK: - Public properties
    
    var result: Result<Any, Error>?
    
    // MARK: - Public methods
    
    func send<Parser>(config: APIRequestConfig<Parser>, completion: @escaping (Result<Parser.Model, Error>) -> Void) {
        switch result {
        case let .success(content):
            if let content = content as? Parser.Model {
                completion(.success(content))
            }
        case let .failure(error):
            completion(.failure(error))
        case .none:
            break
        }
    }
}
