//
//  ImagesServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 23.11.2021.
//

import Foundation

final class ImagesServiceImpl: ImagesService {
    
    // MARK: - Private properties
    
    private let apiRequestSender: APIRequestSender
    
    // MARK: - Initialization
    
    init(apiRequestSender: APIRequestSender) {
        self.apiRequestSender = apiRequestSender
    }
    
    // MARK: - Public methods
    
    func fetchImages(
        query: String,
        itemsPerPage: Int,
        page: Int,
        completion: @escaping (Result<ImagesResponse, Error>) -> Void
    ) {
        let requestConfig = APIRequestsFactory.imagesAPIRequestConfig(
            query: query,
            itemsPerPage: itemsPerPage,
            page: page
        )
        apiRequestSender.send(config: requestConfig, completion: completion)
    }
}
