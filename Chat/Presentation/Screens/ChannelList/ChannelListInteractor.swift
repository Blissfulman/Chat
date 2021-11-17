//
//  ChannelListInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Foundation

protocol ChannelListBusinessLogic: AnyObject {
    func fetchProfile(request: ChannelListModel.FetchProfile.Request)
    func updateProfile(request: ChannelListModel.UpdateProfile.Request)
    func fetchChannelList(request: ChannelListModel.ChannelList.Request)
    func requestAddChannelAlert(request: ChannelListModel.AddChannelAlert.Request)
    func addNewChannel(request: ChannelListModel.NewChannel.Request)
    func updateTheme(request: ChannelListModel.UpdateTheme.Request)
    func openChannel(request: ChannelListModel.OpenChannel.Request)
    func deleteChannel(request: ChannelListModel.DeleteChannel.Request)
}

final class ChannelListInteractor: ChannelListBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelListPresentationLogic
    private let dataManager: DataManager
    private var settingsService: SettingsService
    private let profileDataManager: ProfileDataManager
    private var firestoreManager: FirestoreManagerImpl<Channel>
    private let channelListDataSource: ChannelListDataSourceProtocol
    private var profile: Profile?
    
    // MARK: - Initialization
    
    init(
        presenter: ChannelListPresentationLogic,
        dataManager: DataManager = ServiceLayer.shared.dataManager,
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        profileDataManager: ProfileDataManager = ServiceLayer.shared.gcdProfileDataManager,
        channelListDataSource: ChannelListDataSourceProtocol
    ) {
        self.presenter = presenter
        self.dataManager = dataManager
        self.settingsService = settingsService
        self.profileDataManager = profileDataManager
        self.firestoreManager = FirestoreManagerImpl<Channel>(dataType: .channels)
        self.channelListDataSource = channelListDataSource
    }
    
    // MARK: - ChannelListBusinessLogic
    
    func fetchProfile(request: ChannelListModel.FetchProfile.Request) {
        profileDataManager.fetchProfile { [weak self] result in
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
            case let .success(snapshotChannels):
                self.dataManager.updateChannels(snapshotChannels)
            case let .failure(error):
                let response = ChannelListModel.FetchingChannelsError.Response(error: error)
                self.presenter.presentFetchingChannelsError(response: response)
            }
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
            self?.settingsService.saveTheme(request.theme)
        }
    }
    
    func openChannel(request: ChannelListModel.OpenChannel.Request) {
        guard let channel = channelListDataSource.сhannel(at: request.indexPath) else { return }
        let response = ChannelListModel.OpenChannel.Response(channel: channel, senderName: profile?.fullName)
        presenter.presentSelectedChannel(response: response)
    }
    
    func deleteChannel(request: ChannelListModel.DeleteChannel.Request) {
        guard let channel = channelListDataSource.сhannel(at: request.indexPath) else { return }
        firestoreManager.deleteObject(channel)
    }
}
