//
//  Channel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        guard let name = data["name"] as? String else { return nil }
        self.identifier = snapshot.documentID
        self.name = name
        self.lastMessage = data["lastMessage"] as? String
        self.lastActivity = data["lastActivity"] as? Date
    }
}
