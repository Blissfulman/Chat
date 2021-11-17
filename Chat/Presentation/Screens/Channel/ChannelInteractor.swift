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
    private let settingsService: SettingsService
    private let messagesService: MessagesService
    private let channelDataSource: ChannelDataSourceProtocol
    private let channel: Channel
    private let senderName: String
    
    // MARK: - Initialization
    
    init(
        presenter: ChannelPresentationLogic,
        messagesService: MessagesService,
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        channelDataSource: ChannelDataSourceProtocol,
        channel: Channel,
        senderName: String
    ) {
        self.presenter = presenter
        self.settingsService = settingsService
        self.messagesService = messagesService
        self.channelDataSource = channelDataSource
        self.channel = channel
        self.senderName = senderName
    }
    
    // MARK: - ChannelBusinessLogic
    
    func setupTheme(request: ChannelModel.SetupTheme.Request) {
        let theme = settingsService.getTheme()
        presenter.presentTheme(response: ChannelModel.SetupTheme.Response(theme: theme))
    }
    
    func fetchMessages(request: ChannelModel.FetchMessages.Request) {
        messagesService.setMessagesListener(channel: channel, failureHandler: { [weak self] error in
            let response = ChannelModel.FetchingMessagesError.Response(error: error)
            self?.presenter.presentFetchingMessagesError(response: response)
        })
    }
    
    func sendMessage(request: ChannelModel.SendMessage.Request) {
        guard let text = request.text else { return }
        let newMessage = Message(
            id: "",
            content: text,
            created: Date(),
            senderID: GlobalData.mySenderID,
            senderName: senderName
        )
        messagesService.addNewMessage(newMessage)
        presenter.presentSendMessage(response: ChannelModel.SendMessage.Response())
    }
}
