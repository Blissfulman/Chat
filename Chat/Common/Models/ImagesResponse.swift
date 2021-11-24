//
//  ImagesResponse.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import Foundation

struct ImagesResponse: Decodable {
    
    let totalItems: Int
    let imageItems: [ImageItem]
    
    private enum CodingKeys: String, CodingKey {
        case totalItems = "total"
        case imageItems = "hits"
    }
}

struct ImageItem: Decodable {
    let previewURL: URL?
    let webformatURL: URL?
}
