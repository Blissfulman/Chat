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
    private var settingsService: SettingsService
    private var channelsService: ChannelsService
    private var profileService: ProfileService
    private let channelListDataSource: ChannelListDataSourceProtocol
    private var profile: Profile?
    
    // MARK: - Initialization
    
    init(
        presenter: ChannelListPresentationLogic,
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        channelsService: ChannelsService = ServiceLayer.shared.channelsService,
        profileService: ProfileService = ServiceLayer.shared.profileService,
        channelListDataSource: ChannelListDataSourceProtocol
    ) {
        self.presenter = presenter
        self.settingsService = settingsService
        self.channelsService = channelsService
        self.profileService = profileService
        self.channelListDataSource = channelListDataSource
    }
    
    // MARK: - ChannelListBusinessLogic
    
    func fetchProfile(request: ChannelListModel.FetchProfile.Request) {
        profileService.fetchProfile { [weak self] result in
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
        channelsService.setChannelsListener(failureHandler: { [weak self] error in
            let response = ChannelListModel.FetchingChannelsError.Response(error: error)
            self?.presenter.presentFetchingChannelsError(response: response)
        })
    }
    
    func requestAddChannelAlert(request: ChannelListModel.AddChannelAlert.Request) {
        presenter.presentAddChannelAlert(response: ChannelListModel.AddChannelAlert.Response())
    }
    
    func addNewChannel(request: ChannelListModel.NewChannel.Request) {
        let newChannel = Channel(id: "", name: request.channelName, lastMessage: nil, lastActivity: nil)
        channelsService.addNewChannel(newChannel)
    }
    
    func updateTheme(request: ChannelListModel.UpdateTheme.Request) {
        NavigationController.updateColors(for: request.theme) // Вероятно не должно быть в интеракторе?
        settingsService.saveTheme(request.theme)
    }
    
    func openChannel(request: ChannelListModel.OpenChannel.Request) {
        guard let channel = channelListDataSource.сhannel(at: request.indexPath) else { return }
        let response = ChannelListModel.OpenChannel.Response(channel: channel, senderName: profile?.fullName)
        presenter.presentSelectedChannel(response: response)
    }
    
    func deleteChannel(request: ChannelListModel.DeleteChannel.Request) {
        guard let channel = channelListDataSource.сhannel(at: request.indexPath) else { return }
        channelsService.deleteChannel(channel)
    }
}
