//
//  Channel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Foundation

struct Channel {
    let avatarData: Data?
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessage: Bool
}

extension Channel {
    
    static func mockData() -> [Self] {
        var randomDate: Date {
            Date().addingTimeInterval(TimeInterval(-Int.random(in: 0...432000)))
        }
        
        return [
            Channel(
                avatarData: nil,
                name: "Johnny Watson",
                message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Ronald Robertson",
                message: nil,
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Martha Craig",
                message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Arthur Bell",
                message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Jane Warren",
                message: "Voluptate irure aliquip consectetur commodo ex ex.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Morris Henry",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Irma Flores",
                message: nil,
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Colin Williams",
                message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "John Roberts",
                message: nil,
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Abdulie Gordon",
                message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Entony Torres",
                message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Alex Todd",
                message: nil,
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Samantha Fog",
                message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Richard Adams",
                message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                date: randomDate,
                isOnline: true,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Kate Lima",
                message: "Voluptate irure aliquip consectetur commodo ex ex.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Adam Bruge",
                message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Emma Collins",
                message: nil,
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: false
            ),
            Channel(
                avatarData: nil,
                name: "Duck McRoe",
                message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Erik Grant",
                message: nil,
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            ),
            Channel(
                avatarData: nil,
                name: "Brad Duglas",
                message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
                date: randomDate,
                isOnline: false,
                hasUnreadMessage: true
            )
        ]
    }
}
