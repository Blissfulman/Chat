//
//  Message.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        self.content = data["content"] as? String ?? ""
        let timestamp = data["created"] as? Timestamp
        self.created = timestamp?.dateValue() ?? Date()
        self.senderId = data["senderId"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
    }
}
