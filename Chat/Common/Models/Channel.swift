//
//  Channel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Channel: FirestoreObject, Identifiable {
    
    // MARK: - Public properties
    
    let id: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    var toDictionary: [String: Any] {
        var lastActivityValue: Timestamp?
        if let lastActivity = lastActivity {
            lastActivityValue = Timestamp(date: lastActivity)
        }
        return [
            "identifier": id,
            "name": name,
            "lastMessage": lastMessage as Any,
            "lastActivity": lastActivityValue as Any
        ]
    }
    
    // MARK: - Initialization
    
    init(id: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.id = id
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        guard let name = data["name"] as? String else { return nil }
        self.id = snapshot.documentID
        self.name = name
        self.lastMessage = data["lastMessage"] as? String
        let timestamp = data["lastActivity"] as? Timestamp
        self.lastActivity = timestamp?.dateValue()
    }
    
    init?(dbChannel: DBChannel) {
        guard
            let id = dbChannel.id,
            let name = dbChannel.name
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.lastMessage = dbChannel.lastMessage
        self.lastActivity = dbChannel.lastActivity
    }
}
