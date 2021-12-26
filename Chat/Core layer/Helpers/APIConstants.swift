//
//  APIConstants.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 24.11.2021.
//

import Foundation

enum APIConstants {
    
    static var baseURL = valueForKey("APIBaseURL") ?? ""
    static var apiKey = valueForKey("APIKey") ?? ""
    
    static private func valueForKey(_ key: String) -> String? {
        (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}
