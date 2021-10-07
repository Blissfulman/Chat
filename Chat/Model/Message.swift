//
//  Message.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Foundation

struct Message {
    let text: String
    let date: Date
    let isUnread: Bool
    let isMine: Bool
}

extension Message {
    
    static func mockData() -> [Self] {
        [
            Message(text: "Good morning!", date: Date(), isUnread: false, isMine: true),
            Message(text: "Japan looks amazing!", date: Date(), isUnread: false, isMine: true),
            Message(text: "Do you know what time is it?", date: Date(), isUnread: false, isMine: false),
            Message(text: "It’s morning in Tokyo 😎", date: Date(), isUnread: false, isMine: true),
            Message(text: "What is the most popular meal in Japan?", date: Date(), isUnread: false, isMine: false),
            Message(text: "Do you like it?", date: Date(), isUnread: false, isMine: false),
            Message(text: "I like it", date: Date(), isUnread: false, isMine: true),
            Message(text: "I will write your", date: Date(), isUnread: false, isMine: true),
            Message(text: "Ok, see you", date: Date(), isUnread: false, isMine: false),
            Message(text: "Have a nice day", date: Date(), isUnread: false, isMine: false)
        ]
    }
}
