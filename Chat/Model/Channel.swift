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
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        self.identifier = snapshot.documentID
        self.name = data["name"] as? String ?? ""
        self.lastMessage = data["lastMessage"] as? String
        let timestamp = data["lastActivity"] as? Timestamp
        self.lastActivity = timestamp?.dateValue()
    }
}
