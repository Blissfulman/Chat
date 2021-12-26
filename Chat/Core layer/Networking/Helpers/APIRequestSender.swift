//
//  APIRequestSender.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

protocol APIRequestSender {
    func send<Parser>(config: APIRequestConfig<Parser>, completion: @escaping (Result<Parser.Model, Error>) -> Void)
}
