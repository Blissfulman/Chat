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
    func openChannel(request: ChannelListModel.OpenChannel.Request)
}

final class ChannelListInteractor: ChannelListBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelListPresentationLogic
    private let channelListDataSource: ChannelListDataSourceProtocol
    private var firestoreManager = FirestoreManager<Channel>(dataType: .channels)
    private let settingsManager = SettingsManager()
    private let asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
    private let dataStorageManager: DataStorageManagerProtocol = DataStorageManager.shared
    private var profile: Profile?
    
    // MARK: - Initialization
    
    init(presenter: ChannelListPresentationLogic, channelListDataSource: ChannelListDataSourceProtocol) {
        self.presenter = presenter
        self.channelListDataSource = channelListDataSource
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
        firestoreManager.listener = { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(channels):
                self.dataStorageManager.saveChannels(channels)
            case let .failure(error):
                let response = ChannelListModel.FetchingChannelsError.Response(error: error)
                self.presenter.presentFetchingChannelsError(response: response)
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
        let newChannel = Channel(id: "", name: request.channelName, lastMessage: nil, lastActivity: nil)
        firestoreManager.addObject(newChannel)
    }
    
    func updateTheme(request: ChannelListModel.UpdateTheme.Request) {
        let asyncHandler = GCDAsyncHandler(qos: .userInteractive)
        asyncHandler.handle { [weak self] in
            NavigationController.updateColors(for: request.theme)
            self?.settingsManager.theme = request.theme
        }
    }
    
    func openChannel(request: ChannelListModel.OpenChannel.Request) {
        guard let channel = channelListDataSource.getChannel(at: request.indexPath) else { return }
        let response = ChannelListModel.OpenChannel.Response(channel: channel, senderName: profile?.fullName)
        presenter.presentSelectedChannel(response: response)
    }
}
