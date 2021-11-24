//
//  APIRequestConfig.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

struct APIRequestConfig<Parser: APIParser> {
    let request: APIRequest
    let parser: Parser
}
