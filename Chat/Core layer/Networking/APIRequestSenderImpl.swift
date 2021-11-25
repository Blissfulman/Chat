//
//  APIRequestSenderImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case noData
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "URL error"
        case .noData:
            return "No data"
        case .parsingError:
            return "Data parsing error"
        }
    }
}

final class APIRequestSenderImpl: APIRequestSender {
    
    // MARK: - Public methods
    
    func send<Parser>(config: APIRequestConfig<Parser>, completion: @escaping (Result<Parser.Model, Error>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completion(.failure(NetworkError.badURL))
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                self.mainThreadCompletion(.failure(error), completion: completion)
                return
            }
            guard let data = data else {
                self.mainThreadCompletion(.failure(NetworkError.noData), completion: completion)
                return
            }
            do {
                let parsedModel = try config.parser.parse(data: data)
                self.mainThreadCompletion(.success(parsedModel), completion: completion)
            } catch {
                self.mainThreadCompletion(.failure(NetworkError.parsingError), completion: completion)
            }
        }.resume()
    }
    
    // MARK: - Private methods
    
    private func mainThreadCompletion<Value>(_ value: Value, completion: @escaping (Value) -> Void) {
        DispatchQueue.main.async {
            completion(value)
        }
    }
}
