//
//  ChannelsServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import CoreData

final class ChannelsServiceImpl: ChannelsService {
    
    // MARK: - Public properties
    
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> {
        contentManager.channelListFetchedResultsController
    }
    
    // MARK: - Private properties
    
    private let firestoreManager: FirestoreManagerImpl<Channel>
    private let contentManager: ContentManager
    
    // MARK: - Initialization
    
    init(firestoreManager: FirestoreManagerImpl<Channel>, contentManager: ContentManager) {
        self.firestoreManager = firestoreManager
        self.contentManager = contentManager
    }
    
    // MARK: - Public methods
    
    func setChannelsListener(failureHandler: @escaping (Error) -> Void) {
        firestoreManager.listener = { [weak self] result in
            switch result {
            case let .success(snapshotChannels):
                self?.contentManager.updateChannels(snapshotChannels)
            case let .failure(error):
                failureHandler(error)
            }
        }
    }
    
    func addNewChannel(_ channel: Channel) {
        firestoreManager.addObject(channel)
    }
    
    func deleteChannel(_ channel: Channel) {
        firestoreManager.deleteObject(channel)
    }
}
