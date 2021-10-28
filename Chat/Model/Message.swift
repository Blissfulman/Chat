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
    
    var toDictionary: [String: Any] {
        [
            "content": content,
            "created": Timestamp(date: created),
            "senderID": senderID,
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
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        guard
            let content = data["content"] as? String,
            let timestamp = data["created"] as? Timestamp,
            let senderID = data["senderID"] as? String,
            let senderName = data["senderName"] as? String
        else {
            return nil
        }
        self.content = content
        self.created = timestamp.dateValue()
        self.senderID = senderID
        self.senderName = senderName
    }
}
