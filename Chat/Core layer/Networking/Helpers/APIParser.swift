//
//  APIParser.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

protocol APIParser {
    associatedtype Model: Decodable
    func parse(data: Data) throws -> Model
}

extension APIParser {
    
    func parse(data: Data) throws -> Model {
        try JSONDecoder().decode(Model.self, from: data)
    }
}
