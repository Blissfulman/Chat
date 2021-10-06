//
//  Conversation.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Foundation

struct Conversation {
    let avatarData: Data?
    let name: String?
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessage: Bool
}

extension Conversation {
    
    static func mockData() -> [Self] {
        [
            Conversation(
                avatarData: nil,
                name: "Johnny Watson",
                message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                date: Date(),
                isOnline: true,
                hasUnreadMessage: false
            ),
            Conversation(
                avatarData: nil,
                name: "Ronald Robertson",
                message: nil,
                date: Date(),
                isOnline: true,
                hasUnreadMessage: true
            ),
            Conversation(
                avatarData: nil,
                name: "Martha Craig",
                message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                date: Date(),
                isOnline: true,
                hasUnreadMessage: true
            ),
            Conversation(
                avatarData: nil,
                name: "Arthur Bell",
                message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                date: Date(),
                isOnline: true,
                hasUnreadMessage: false
            ),
            Conversation(
                avatarData: nil,
                name: "Jane Warren",
                message: "Voluptate irure aliquip consectetur commodo ex ex.",
                date: Date(),
                isOnline: false,
                hasUnreadMessage: false
            ),
            Conversation(
                avatarData: nil,
                name: "Morris Henry",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: Date(),
                isOnline: false,
                hasUnreadMessage: true
            ),
            Conversation(
                avatarData: nil,
                name: "Irma Flores",
                message: nil,
                date: Date(),
                isOnline: true,
                hasUnreadMessage: false
            ),
            Conversation(
                avatarData: nil,
                name: "Colin Williams",
                message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.",
                date: Date(),
                isOnline: true,
                hasUnreadMessage: true
            ),
            Conversation(
                avatarData: nil,
                name: "John Roberts",
                message: nil,
                date: Date(),
                isOnline: false,
                hasUnreadMessage: true
            ),
            Conversation(
                avatarData: nil,
                name: "Abdulie Gordon",
                message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                date: Date(),
                isOnline: true,
                hasUnreadMessage: true
            )
        ]
    }
}
