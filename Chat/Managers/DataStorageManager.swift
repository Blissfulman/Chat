//
//  DataStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

protocol DataStorageManagerProtocol {
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые каналы.
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> { get }
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые сообщения указанного канала.
    /// - Parameter channel: Канал, чьи сообщения контроллер будет отслеживать.
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage>
    /// Сохранение всех несохранённых данных.
    func saveData()
    /// Сохранение каналов.
    /// - Parameter channels: Сохраняемые каналы.
    func saveChannels(_ channels: [Channel])
    /// Сохранение сообщений.
    /// - Parameters:
    ///   - messages: Сохраняемые сообщения.
    ///   - channel: Канал, к которому эти сообщения относятся.
    func saveMessages(_ messages: [Message], forChannel channel: Channel)
    /// Получение всех сохранённых каналов.
    func fetchChannels() -> [Channel]
    /// Получение всех сообщений канала.
    /// - Parameter channel: Канал, сообщения которого необходимо получить.
    func fetchMessages(forChannel channel: Channel) -> [Message]
    /// Удаление указанного канала.
    /// - Parameter channel: Удаляемый канал.
    func deleteChannel(_ channel: Channel)
    /// Удаление всех сохранённых данных.
    func deleteAllData()
}

final class DataStorageManager: DataStorageManagerProtocol {
    
    // MARK: - Static properties
    
    static let shared = DataStorageManager()
    
    // MARK: - Public properties
    
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> {
        storage.fetchedResultsController(for: DBChannel.self, sortDescriptorKey: #keyPath(DBChannel.lastActivity))
    }
    
    // MARK: - Private properties
    
    private let storage = CoreDataStorage(modelName: "Chat")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public methods
    
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage> {
        let channelMessagesPredicate = makeChannelMessagesPredicate(forChannel: channel)
        return storage.fetchedResultsController(
            for: DBMessage.self,
            sortDescriptorKey: #keyPath(DBMessage.created),
            predicate: channelMessagesPredicate
        )
    }
    
    func saveData() {
        storage.saveChanges()
    }
    
    func saveChannels(_ channels: [Channel]) {
        channels.forEach { channel in
            storage.createObject(from: DBChannel.self) { dbChannel in
                dbChannel.id = channel.id
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
            }
        }
        saveData()
    }
    
    func saveMessages(_ messages: [Message], forChannel channel: Channel) {
        let channelIDPredicate = makeChannelIDPredicate(forChannel: channel)
        let channel = storage.fetchDataInBackground(for: DBChannel.self, predicate: channelIDPredicate).first
        messages.forEach { message in
            storage.createObject(from: DBMessage.self) { dbMessage in
                dbMessage.content = message.content
                dbMessage.created = message.created
                dbMessage.senderID = message.senderID
                dbMessage.senderName = message.senderName
                dbMessage.channel = channel
            }
        }
        saveData()
    }
    
    func fetchChannels() -> [Channel] {
        let dbChannels = storage.fetchData(for: DBChannel.self)
        return dbChannels.compactMap { Channel(dbChannel: $0) }
    }
    
    func fetchMessages(forChannel channel: Channel) -> [Message] {
        let channelMessagesPredicate = makeChannelMessagesPredicate(forChannel: channel)
        let dbMessages = storage.fetchData(for: DBMessage.self, predicate: channelMessagesPredicate)
        return dbMessages.compactMap { Message(dbMessage: $0) }
    }
    
    func deleteChannel(_ channel: Channel) {
        let channelIDPredicate = makeChannelIDPredicate(forChannel: channel)
        let channels = storage.fetchDataInBackground(for: DBChannel.self, predicate: channelIDPredicate)
        storage.deleteObjects(channels)
    }
    
    func deleteAllData() {
        let channels = storage.fetchDataInBackground(for: DBChannel.self)
        storage.deleteObjects(channels)
        let messages = storage.fetchDataInBackground(for: DBMessage.self)
        storage.deleteObjects(messages)
    }
        
    // MARK: - Private methods
    
    private func makeChannelIDPredicate(forChannel channel: Channel) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "id == '\(channel.id)'")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
    
    private func makeChannelMessagesPredicate(forChannel channel: Channel) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "channel.id == '\(channel.id)'")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
}
