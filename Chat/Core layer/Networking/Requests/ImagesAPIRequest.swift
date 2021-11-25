//
//  ImagesAPIRequest.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

struct ImagesAPIRequest: APIRequest {
    
    // MARK: - Public properties
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: APIConstants.baseURL + query(queryParameters)) else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    // MARK: - Private properties
    
    private let query: String
    private let itemsPerPage: Int
    private let page: Int
    private var queryParameters: [String: String] {
        [
            "key": APIConstants.apiKey,
            "q": query.urlEncoded() ?? "",
            "per_page": "\(itemsPerPage)",
            "page": "\(page)"
        ]
    }
    
    // MARK: - Initialization
    
    init(query: String, itemsPerPage: Int, page: Int) {
        self.query = query
        self.itemsPerPage = itemsPerPage
        self.page = page
    }
}
