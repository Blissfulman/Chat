//
//  AsyncHandlerQoS.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

enum AsyncHandlerQoS {
    case userInteractive
    case userInitiated
    case utility
    case background
    
    var gcdQoS: DispatchQoS {
        switch self {
        case .userInteractive:
            return .userInteractive
        case .userInitiated:
            return .userInitiated
        case .utility:
            return .utility
        case .background:
            return .background
        }
    }
    
    var operationsQoS: QualityOfService {
        switch self {
        case .userInteractive:
            return .userInteractive
        case .userInitiated:
            return .userInitiated
        case .utility:
            return .utility
        case .background:
            return .background
        }
    }
}
