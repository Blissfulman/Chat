//
//  Message.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Message {
    
    // MARK: - Public properties
    
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
    
    var toDict: [String: Any] {
        [
            "content": content,
            "created": Timestamp(date: created),
            "senderId": senderID,
            "senderName": senderName
        ]
    }
    
    // MARK: - Initialization
    
    init(content: String, created: Date, senderID: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        self.content = data["content"] as? String ?? ""
        let timestamp = data["created"] as? Timestamp
        self.created = timestamp?.dateValue() ?? Date()
        self.senderID = data["senderId"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
    }
}
