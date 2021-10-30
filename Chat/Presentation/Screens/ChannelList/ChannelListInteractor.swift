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
    func addNewChannel(request: ChannelListModel.NewChannel.Request)
    func updateTheme(request: ChannelListModel.UpdateTheme.Request)
}

final class ChannelListInteractor: ChannelListBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelListPresentationLogic
    private let db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private let settingsManager = SettingsManager()
    private let asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
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
                let response = ChannelListModel.UpdateProfile.Response(
                    avatarImageData: profile.avatarData,
                    senderName: profile.fullName
                )
                self?.presenter.presentProfileData(response: response)
            }
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
            if let error = error {
                let response = ChannelListModel.FetchingChannelsError.Response(error: error)
                self?.presenter.presentFetchingChannelsError(response: response)
            } else {
                if let channelSnapshots = snapshot?.documents {
                    let channels = channelSnapshots
                        .compactMap { Channel(snapshot: $0) }
                        .sorted { $0.name > $1.name }
                    let response = ChannelListModel.ChannelList.Response(channels: channels)
                    self?.presenter.presentChannelList(response: response)
                }
            }
        }
    }
    
    func addNewChannel(request: ChannelListModel.NewChannel.Request) {
        guard let channelName = request.channelName, !channelName.isEmpty else { return }
        let newChannel = Channel(identifier: "", name: channelName, lastMessage: nil, lastActivity: nil)
        reference.addDocument(data: newChannel.toDictionary)
    }
    
    func updateTheme(request: ChannelListModel.UpdateTheme.Request) {
        let asyncHandler = GCDAsyncHandler(qos: .userInteractive)
        asyncHandler.handle { [weak self] in
            NavigationController.updateColors(for: request.theme)
            self?.settingsManager.theme = request.theme
        }
    }
}
