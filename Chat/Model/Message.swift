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
        var randomDate: Date {
            Date().addingTimeInterval(TimeInterval(Int.random(in: 0...86400)))
        }
        
        return [
            Message(text: "Good morning!", date: randomDate, isUnread: false, isMine: true),
            Message(text: "Japan looks amazing!", date: randomDate, isUnread: false, isMine: true),
            Message(text: "Do you know what time is it?", date: randomDate, isUnread: false, isMine: false),
            Message(text: "It’s morning in Tokyo 😎", date: randomDate, isUnread: false, isMine: true),
            Message(text: "What is the most popular meal in Japan?", date: randomDate, isUnread: false, isMine: false),
            Message(text: "Do you like it?", date: randomDate, isUnread: false, isMine: false),
            Message(text: "I like it", date: randomDate, isUnread: false, isMine: true),
            Message(text: "I will write your", date: randomDate, isUnread: false, isMine: true),
            Message(text: "Ok, see you", date: randomDate, isUnread: false, isMine: false),
            Message(text: "Have a nice day", date: randomDate, isUnread: false, isMine: false)
        ]
    }
}
