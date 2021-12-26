//
//  MessagesServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import CoreData

final class MessagesServiceImpl: MessagesService {
    
    // MARK: - Private properties
    
    private let firestoreManager: FirestoreManagerImpl<Message>
    private let contentManager: ContentManager
    
    // MARK: - Initialization
    
    init(firestoreManager: FirestoreManagerImpl<Message>, contentManager: ContentManager) {
        self.firestoreManager = firestoreManager
        self.contentManager = contentManager
    }
    
    // MARK: - Public methods
    
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage> {
        contentManager.channelFetchedResultsController(forChannel: channel)
    }

    func setMessagesListener(channel: Channel, failureHandler: @escaping (Error) -> Void) {
        firestoreManager.listener = { [weak self] result in
            switch result {
            case let .success(snapshotMessages):
                self?.contentManager.updateMessages(snapshotMessages, forChannel: channel)
            case let .failure(error):
                failureHandler(error)
            }
        }
    }
    
    func addNewMessage(_ message: Message) {
        firestoreManager.addObject(message)
    }
}
