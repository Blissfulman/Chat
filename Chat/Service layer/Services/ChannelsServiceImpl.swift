//
//  ChannelsServiceImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

final class ChannelsServiceImpl: ChannelsService {
    
    // MARK: - Private properties
    
    private var firestoreManager: FirestoreManagerImpl<Channel>
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