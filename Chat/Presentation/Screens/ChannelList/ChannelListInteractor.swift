//
//  ChannelListInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Firebase

protocol ChannelListBusinessLogic: AnyObject {
    func fetchProfile(request: ChannelListModel.FetchProfile.Request)
    func updateProfile(request: ChannelListModel.UpdateProfile.Request)
    func fetchChannelList(request: ChannelListModel.ChannelList.Request)
    func requestAddChannelAlert(request: ChannelListModel.AddChannelAlert.Request)
    func addNewChannel(request: ChannelListModel.NewChannel.Request)
    func updateTheme(request: ChannelListModel.UpdateTheme.Request)
}

final class ChannelListInteractor: ChannelListBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelListPresentationLogic
    private let database = Firestore.firestore()
    private lazy var reference = database.collection("channels")
    private let settingsManager = SettingsManager()
    private let asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
    private let dataStorageManager: DataStorageManagerProtocol = DataStorageManager.shared
    private var profile: Profile?
    
    // MARK: - Initialization
    
    init(presenter: ChannelListPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - ChannelListBusinessLogic
    
    func fetchProfile(request: ChannelListModel.FetchProfile.Request) {
        asyncDataManager.fetchProfile { [weak self] result in
            if case let .success(profile) = result {
                guard let profile = profile else { return }
                self?.profile = profile
            }
            let response = ChannelListModel.UpdateProfile.Response(
                avatarImageData: self?.profile?.avatarData,
                senderName: self?.profile?.fullName
            )
            self?.presenter.presentProfileData(response: response)
        }
    }
    
    func updateProfile(request: ChannelListModel.UpdateProfile.Request) {
        profile = request.profile
        let response = ChannelListModel.UpdateProfile.Response(
            avatarImageData: request.profile.avatarData,
            senderName: request.profile.fullName
        )
        presenter.presentProfileData(response: response)
    }
    
    func fetchChannelList(request: ChannelListModel.ChannelList.Request) {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                let response = ChannelListModel.FetchingChannelsError.Response(error: error)
                self.presenter.presentFetchingChannelsError(response: response)
            } else {
                if let channelSnapshots = snapshot?.documents {
                    let channels = channelSnapshots.compactMap { Channel(snapshot: $0) }
                    let sortedChannels = self.sortChannels(channels)
                    
                    self.dataStorageManager.saveChannels(channels)
                    
                    let response = ChannelListModel.ChannelList.Response(channels: sortedChannels)
                    self.presenter.presentChannelList(response: response)
                }
            }
            // TEMP: Временно для демонстранции успешного сохранения и чтения данных из CoreData
            let channels = self.dataStorageManager.fetchChannels()
            print("SAVED CHANNELS:")
            channels.forEach { print($0) }
        }
    }
    
    func requestAddChannelAlert(request: ChannelListModel.AddChannelAlert.Request) {
        presenter.presentAddChannelAlert(response: ChannelListModel.AddChannelAlert.Response())
    }
    
    func addNewChannel(request: ChannelListModel.NewChannel.Request) {
        let newChannel = Channel(identifier: "", name: request.channelName, lastMessage: nil, lastActivity: nil)
        reference.addDocument(data: newChannel.toDictionary)
    }
    
    func updateTheme(request: ChannelListModel.UpdateTheme.Request) {
        let asyncHandler = GCDAsyncHandler(qos: .userInteractive)
        asyncHandler.handle { [weak self] in
            NavigationController.updateColors(for: request.theme)
            self?.settingsManager.theme = request.theme
        }
    }
    
    // MARK: - Private methods
    
    private func sortChannels(_ channels: [Channel]) -> [Channel] {
        let activeChannels = channels
            .filter { $0.lastActivity != nil }
            .sorted {
                if let firstDate = $0.lastActivity,
                   let secondDate = $1.lastActivity {
                    return firstDate > secondDate
                } else {
                    return true
                }
            }
        let inactiveChannels = channels
            .filter { $0.lastActivity == nil }
            .sorted { $0.name < $1.name }
        return activeChannels + inactiveChannels
    }
}
