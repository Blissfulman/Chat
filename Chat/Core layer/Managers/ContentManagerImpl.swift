//
//  ContentManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

final class ContentManagerImpl: ContentManager {
    
    // MARK: - Public properties
    
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> {
        storage.fetchedResultsController(
            for: DBChannel.self,
            sortDescriptorKey: #keyPath(DBChannel.lastActivity),
            predicate: nil
        )
    }
    
    // MARK: - Private properties
    
    private let storage: CoreDataStorage
    
    // MARK: - Initialization
    
    init(storage: CoreDataStorage) {
        self.storage = storage
    }
    
    // MARK: - Public methods
    
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage> {
        let channelMessagesPredicate = makeChannelMessagesPredicate(channelID: channel.id)
        return storage.fetchedResultsController(
            for: DBMessage.self,
            sortDescriptorKey: #keyPath(DBMessage.created),
            predicate: channelMessagesPredicate
        )
    }
    
    func saveData() {
        storage.saveChanges()
    }
    
    func updateChannels(_ snapshotChannels: SnapshotObjects<Channel>) {
        createChannels(snapshotChannels.addedObjects)
        modifyChannels(snapshotChannels.modifiedObjects)
        snapshotChannels.removedObjects.forEach { deleteChannel($0) }
        saveData()
    }
    
    func updateMessages(_ snapshotMessages: SnapshotObjects<Message>, forChannel channel: Channel) {
        createMessages(snapshotMessages.addedObjects, forChannel: channel)
        modifyMessages(snapshotMessages.modifiedObjects)
        snapshotMessages.removedObjects.forEach { deleteMessage($0) }
        saveData()
    }
    
    // MARK: - Private methods
    
    /// Добавление в хранилище новых каналов.
    /// - Parameter channels: Каналы, которые необходимо добавить в хранилище.
    private func createChannels(_ channels: [Channel]) {
        guard !channels.isEmpty else { return }
        let savedChannelsIDs = fetchAllChannels().map { $0.id }
        
        channels.forEach { channel in
            guard !savedChannelsIDs.contains(channel.id) else { return }
            storage.createObject(from: DBChannel.self) { dbChannel in
                dbChannel.id = channel.id
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
            }
        }
    }
    
    /// Добавление в хранилище новых сообщений.
    /// - Parameters:
    ///   - messages: Сообщения, которые необходимо добавить в хранилище.
    ///   - channel: Канал, к которому эти сообщения относятся.
    private func createMessages(_ messages: [Message], forChannel channel: Channel) {
        guard !messages.isEmpty else { return }
        let savedMessagesIDs = fetchAllMessages(forChannel: channel).map { $0.id }
        
        let channelIDPredicate = makeChannelIDPredicate(channelID: channel.id)
        let dbChannel = storage.fetchObjects(for: DBChannel.self, predicate: channelIDPredicate).first
        
        messages.forEach { message in
            guard !savedMessagesIDs.contains(message.id) else { return }
            storage.createObject(from: DBMessage.self) { dbMessage in
                dbMessage.id = message.id
                dbMessage.content = message.content
                dbMessage.created = message.created
                dbMessage.senderID = message.senderID
                dbMessage.senderName = message.senderName
                dbMessage.channel = dbChannel
            }
        }
    }
    
    /// Получение всех каналов.
    private func fetchAllChannels() -> [Channel] {
        let dbChannels = storage.fetchObjects(for: DBChannel.self, predicate: nil)
        return dbChannels.compactMap { Channel(dbChannel: $0) }
    }
    
    /// Получение всех сообщений указанного канала.
    /// - Parameter channel: Канал, сообщения которого необходимо получить.
    private func fetchAllMessages(forChannel channel: Channel) -> [Message] {
        let channelMessagesPredicate = makeChannelMessagesPredicate(channelID: channel.id)
        let dbMessages = storage.fetchObjects(for: DBMessage.self, predicate: channelMessagesPredicate)
        return dbMessages.compactMap { Message(dbMessage: $0) }
    }
    
    /// Обновление данных у имеющихся в хранилище каналах.
    /// - Parameter channels: Каналы с обновлёнными данными.
    private func modifyChannels(_ channels: [Channel]) {
        channels.forEach { channel in
            let channelIDPredicate = makeChannelIDPredicate(channelID: channel.id)
            let dbChannel = storage.fetchObjects(for: DBChannel.self, predicate: channelIDPredicate).first
            dbChannel?.name = channel.name
            dbChannel?.lastMessage = channel.lastMessage
            dbChannel?.lastActivity = channel.lastActivity
        }
    }
    
    /// Обновление данных у имеющихся в хранилище сообщениях.
    /// - Parameter messages: Сообщения с обновлёнными данными.
    private func modifyMessages(_ messages: [Message]) {
        messages.forEach { message in
            let messageIDPredicate = makeMessageIDPredicate(messageID: message.id)
            let dbMessage = storage.fetchObjects(for: DBMessage.self, predicate: messageIDPredicate).first
            dbMessage?.content = message.content
            dbMessage?.created = message.created
            dbMessage?.senderID = message.senderID
            dbMessage?.senderName = message.senderName
        }
    }
    
    private func deleteChannel(_ channel: Channel) {
        let channelIDPredicate = makeChannelIDPredicate(channelID: channel.id)
        let channels = storage.fetchObjects(for: DBChannel.self, predicate: channelIDPredicate)
        storage.deleteObjects(channels)
    }
    
    private func deleteMessage(_ message: Message) {
        let messageIDPredicate = makeMessageIDPredicate(messageID: message.id)
        let messages = storage.fetchObjects(for: DBMessage.self, predicate: messageIDPredicate)
        storage.deleteObjects(messages)
    }
    
    private func makeChannelIDPredicate(channelID: Channel.ID) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "id == %@", channelID)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
    
    private func makeMessageIDPredicate(messageID: Message.ID) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "id == %@", messageID)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
    
    private func makeChannelMessagesPredicate(channelID: Channel.ID) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "channel.id == %@", channelID)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
}
