//
//  ImagesService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

protocol ImagesService {
    func fetchImages(
        query: String,
        itemsPerPage: Int,
        page: Int,
        completion: @escaping (Result<ImagesResponse, Error>) -> Void
    )
}
