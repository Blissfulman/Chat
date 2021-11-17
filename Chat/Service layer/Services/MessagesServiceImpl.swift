//
//  MessagesServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

final class MessagesServiceImpl: MessagesService {
    
    // MARK: - Private properties
    
    private var firestoreManager: FirestoreManagerImpl<Message>
    private let dataManager: DataManager
    
    // MARK: - Initialization
    
    init(firestoreManager: FirestoreManagerImpl<Message>, dataManager: DataManager) {
        self.firestoreManager = firestoreManager
        self.dataManager = dataManager
    }
    
    // MARK: - Public methods
    
    func setMessagesListener(channel: Channel, failureHandler: @escaping (Error) -> Void) {
        firestoreManager.listener = { [weak self] result in
            switch result {
            case let .success(snapshotMessages):
                self?.dataManager.updateMessages(snapshotMessages, forChannel: channel)
            case let .failure(error):
                failureHandler(error)
            }
        }
    }
    
    func addNewMessage(_ message: Message) {
        firestoreManager.addObject(message)
    }
}
