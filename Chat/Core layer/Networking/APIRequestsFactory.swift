//
//  APIRequestsFactory.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

enum APIRequestsFactory {
    
    static func imagesAPIRequestConfig(
        query: String,
        itemsPerPage: Int,
        page: Int
    ) -> APIRequestConfig<ImagesResponseParser> {
        let request = ImagesAPIRequest(query: query, itemsPerPage: itemsPerPage, page: page)
        return APIRequestConfig(request: request, parser: ImagesResponseParser())
    }
}
