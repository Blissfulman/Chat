//
//  ServiceLayer.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Foundation

final class ServiceLayer {
    
    // MARK: - Static properties
    
    static let shared = ServiceLayer()
    
    // MARK: - Public properties
    
    lazy var settingsService: SettingsService = SettingsServiceImpl(settingsManager: settingsManager)
    lazy var channelsService: ChannelsService = ChannelsServiceImpl(
        firestoreManager: FirestoreManagerImpl<Channel>(dataType: .channels),
        dataManager: dataManager
    )
    
    lazy var dataManager: DataManager = CoreDataManagerImpl(storage: coreDataStorage)
    lazy var settingsManager: SettingsManager = SettingsManagerImpl(
        fileStorageManager: fileStorageManager,
        keychainStorage: keychainStorage
    )
    lazy var gcdProfileDataManager: ProfileDataManager = ProfileDataManagerImpl(
        syncProfileDataManager: syncProfileDataManager,
        asyncHandlerType: .gcd
    )
    lazy var operationsProfileDataManager: ProfileDataManager = ProfileDataManagerImpl(
        syncProfileDataManager: syncProfileDataManager,
        asyncHandlerType: .operations
    )
    
    // MARK: - Private properties
    
    private lazy var syncProfileDataManager: SyncProfileDataManager = SyncProfileDataManagerImpl(
        fileStorageManager: fileStorageManager
    )
    
    private lazy var coreDataStorage: CoreDataStorage = CoreDataStorageImpl(modelName: CoreConstants.storageNameKey)
    private lazy var fileStorageManager: FileStorageManager = FileStorageManagerImpl()
    private lazy var keychainStorage: KeychainStorage = KeychainStorageImpl(storageNameKey: CoreConstants.storageNameKey)
    
    // MARK: - Initialization
    
    private init() {}
}
