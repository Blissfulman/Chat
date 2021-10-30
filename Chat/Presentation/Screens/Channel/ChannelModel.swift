//
//  ChannelModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

enum ChannelModel {
    
    enum FetchTheme {
        struct Request {}
        struct Response {
            let theme: Theme
        }
        struct ViewModel {
            let theme: Theme
        }
    }
    
    enum FetchMessages {
        struct Request {}
        struct Response {
            let messages: [Message]
        }
        struct ViewModel {
            let messages: [Message]
        }
    }
    
    enum FetchingMessagesError {
        struct Response {
            let error: Error
        }
        struct ViewModel {
            let title: String
            let message: String
        }
    }
    
    enum SendMessage {
        struct Request {
            let text: String
        }
    }
}
