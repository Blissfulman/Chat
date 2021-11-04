//
//  FirestoreManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 04.11.2021.
//

import Firebase

protocol FirestoreManagerProtocol {
    var reference: CollectionReference { get }
}

final class FirestoreManager: FirestoreManagerProtocol {
    
    // MARK: - Nested types
    
    enum DataType {
        case channels
        case messages(channelID: String)
    }
    
    // MARK: - Public properties
    
    lazy var reference: CollectionReference = {
        switch dataType {
        case .channels:
            return database.collection("channels")
        case let .messages(channelID):
            return database.collection("channels").document(channelID).collection("messages")
        }
    }()
    
    // MARK: - Private properties
    
    private let dataType: DataType
    private let database = Firestore.firestore()
    
    // MARK: - Initialization
    
    init(dataType: DataType) {
        self.dataType = dataType
    }
}
