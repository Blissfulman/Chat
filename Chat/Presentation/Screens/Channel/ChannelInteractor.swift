//
//  ChannelInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

protocol ChannelBusinessLogic: AnyObject {
    func setupTheme(request: ChannelModel.SetupTheme.Request)
    func fetchMessages(request: ChannelModel.FetchMessages.Request)
    func sendMessage(request: ChannelModel.SendMessage.Request)
}

final class ChannelInteractor: ChannelBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelPresentationLogic
    private let channelDataSource: ChannelDataSourceProtocol
    private let channel: Channel
    private let senderName: String
    private var firestoreManager: FirestoreManager<Message>
    private let settingsManager = SettingsManager()
    private let dataStorageManager: DataStorageManagerProtocol = DataStorageManager.shared
    
    // MARK: - Initialization
    
    init(
        presenter: ChannelPresentationLogic,
        channelDataSource: ChannelDataSourceProtocol,
        channel: Channel,
        senderName: String
    ) {
        self.presenter = presenter
        self.channelDataSource = channelDataSource
        self.channel = channel
        self.senderName = senderName
        self.firestoreManager = FirestoreManager<Message>(dataType: .messages(channelID: channel.id))
    }
    
    // MARK: - ChannelBusinessLogic
    
    func setupTheme(request: ChannelModel.SetupTheme.Request) {
        let theme = settingsManager.theme
        presenter.presentTheme(response: ChannelModel.SetupTheme.Response(theme: theme))
    }
    
    func fetchMessages(request: ChannelModel.FetchMessages.Request) {
        firestoreManager.listener = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(snapshotMessages):
                self.dataStorageManager.updateMessages(snapshotMessages, forChannel: self.channel)
            case let .failure(error):
                let response = ChannelModel.FetchingMessagesError.Response(error: error)
                self.presenter.presentFetchingMessagesError(response: response)
            }
        }
    }
    
    func sendMessage(request: ChannelModel.SendMessage.Request) {
        guard let text = request.text else { return }
        let newMessage = Message(
            id: "",
            content: text,
            created: Date(),
            senderID: SettingsManager.mySenderID,
            senderName: senderName
        )
        firestoreManager.addObject(newMessage)
        presenter.presentSendMessage(response: ChannelModel.SendMessage.Response())
    }
}
