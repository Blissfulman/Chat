//
//  Message.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Message: FirestoreObject, Identifiable {
    
    // MARK: - Public properties
    
    let id: String
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
    
    var toDictionary: [String: Any] {
        [
            "content": content,
            "created": Timestamp(date: created),
            "senderId": senderID,
            "senderName": senderName
        ]
    }
    
    // MARK: - Initialization
    
    init(id: String, content: String, created: Date, senderID: String, senderName: String) {
        self.id = id
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        // TEMP: временное решение пока есть сообщения с обоими вариантами ключей
        let senderID = data["senderID"] as? String
        let senderId = data["senderId"] as? String
        guard
            let content = data["content"] as? String,
            let timestamp = data["created"] as? Timestamp,
            let totalSenderID = senderID ?? (senderId ?? nil),
            let senderName = data["senderName"] as? String
        else {
            return nil
        }
        self.id = snapshot.documentID
        self.content = content
        self.created = timestamp.dateValue()
        self.senderID = totalSenderID
        self.senderName = senderName
    }
    
    init?(dbMessage: DBMessage) {
        guard
            let id = dbMessage.id,
            let content = dbMessage.content,
            let created = dbMessage.created,
            let senderID = dbMessage.senderID,
            let senderName = dbMessage.senderName
        else {
            return nil
        }
        self.id = id
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
}
