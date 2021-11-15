//
//  Channel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.10.2021.
//

import Firebase

struct Channel {
    
    // MARK: - Public properties
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    var toDictionary: [String: Any] {
        var lastActivityValue: Timestamp?
        if let lastActivity = lastActivity {
            lastActivityValue = Timestamp(date: lastActivity)
        }
        return [
            "identifier": identifier,
            "name": name,
            "lastMessage": lastMessage as Any,
            "lastActivity": lastActivityValue as Any
        ]
    }
    
    // MARK: - Initialization
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        guard let name = data["name"] as? String else { return nil }
        self.identifier = snapshot.documentID
        self.name = name
        self.lastMessage = data["lastMessage"] as? String
        let timestamp = data["lastActivity"] as? Timestamp
        self.lastActivity = timestamp?.dateValue()
    }
    
    init?(dbChannel: DBChannel) {
        guard
            let identifier = dbChannel.identifier,
            let name = dbChannel.name
        else {
            return nil
        }
        self.identifier = identifier
        self.name = name
        self.lastMessage = dbChannel.lastMessage
        self.lastActivity = dbChannel.lastActivity
    }
}
