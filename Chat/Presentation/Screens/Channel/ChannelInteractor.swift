//
//  ChannelInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Firebase

protocol ChannelBusinessLogic: AnyObject {
    func fetchTheme(request: ChannelModel.FetchTheme.Request)
    func fetchMessages(request: ChannelModel.FetchMessages.Request)
    func sendMessage(request: ChannelModel.SendMessage.Request)
}

final class ChannelInteractor: ChannelBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ChannelPresentationLogic
    private let channel: Channel
    private let senderName: String
    private let database = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        database.collection("channels").document(channel.identifier).collection("messages")
    }()
    private let settingsManager = SettingsManager()
    private let dataStorageManager: DataStorageManagerProtocol = DataStorageManager.shared
    
    // MARK: - Initialization
    
    init(presenter: ChannelPresentationLogic, channel: Channel, senderName: String) {
        self.presenter = presenter
        self.channel = channel
        self.senderName = senderName
    }
    
    // MARK: - ChannelBusinessLogic
    
    func fetchTheme(request: ChannelModel.FetchTheme.Request) {
        let theme = settingsManager.theme
        presenter.presentTheme(response: ChannelModel.FetchTheme.Response(theme: theme))
    }
    
    func fetchMessages(request: ChannelModel.FetchMessages.Request) {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                let response = ChannelModel.FetchingMessagesError.Response(error: error)
                self.presenter.presentFetchingMessagesError(response: response)
            } else {
                if let messageSnapshots = snapshot?.documents {
                    let messages = messageSnapshots
                        .compactMap { Message(snapshot: $0) }
                        .sorted { $0.created > $1.created }
                    
                    self.dataStorageManager.saveMessages(messages, forChannel: self.channel)
                    
                    let response = ChannelModel.FetchMessages.Response(messages: messages)
                    self.presenter.presentMessages(response: response)
                }
            }
        }
    }
    
    func sendMessage(request: ChannelModel.SendMessage.Request) {
        guard let text = request.text else { return }
        let newMessage = Message(
            content: text,
            created: Date(),
            senderID: SettingsManager.mySenderID,
            senderName: senderName
        )
        reference.addDocument(data: newMessage.toDictionary)
        presenter.presentSendMessage(response: ChannelModel.SendMessage.Response())
    }
}
