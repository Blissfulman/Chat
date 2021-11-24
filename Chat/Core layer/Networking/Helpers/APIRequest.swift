//
//  APIRequest.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

protocol APIRequest {
    var urlRequest: URLRequest? { get }
}

extension APIRequest {
    
    func query(_ parameters: [String: String]) -> String {
        var components = [(String, String)]()
        
        for key in parameters.keys.sorted(by: <) {
            if let value = parameters[key] {
                components.append((key, value))
            }
        }
        return "?" + components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
