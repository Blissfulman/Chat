//
//  DataStorageManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

protocol DataStorageManagerProtocol {
    /// Сохранение всех несохранённых данных.
    func saveData()
    /// Сохранение каналов.
    /// - Parameter channels: Каналы.
    func saveChannels(_ channels: [Channel])
    /// Сохранение сообщений.
    /// - Parameters:
    ///   - messages: Сообщения.
    ///   - channel: Канал, к которому эти сообщения относятся.
    func saveMessages(_ messages: [Message], forChannel channel: Channel)
    /// Получение всех сохранённых каналов.
    func fetchChannels() -> [Channel]
    /// Получение всех сообщений канала.
    /// - Parameter channel: Канал, сообщения которого необходимо получить.
    func fetchMessages(forChannel channel: Channel) -> [Message]
    /// Удаление всех сохранённых данных.
    func deleteAllData()
}

final class DataStorageManager: DataStorageManagerProtocol {
    
    // MARK: - Static properties
    
    static let shared = DataStorageManager()
    
    // MARK: - Private properties
    
    private let storage = CoreDataStorage(modelName: "Chat")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public methods
    
    func saveData() {
        storage.saveChanges()
    }
    
    func saveChannels(_ channels: [Channel]) {
        channels.forEach { channel in
            storage.createObject(from: DBChannel.self) { dbChannel in
                dbChannel.identifier = channel.identifier
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
    
    func deleteAllData() {
        let channels = storage.fetchDataInBackground(for: DBChannel.self)
        storage.deleteObjects(channels)
        let messages = storage.fetchDataInBackground(for: DBMessage.self)
        storage.deleteObjects(messages)
    }
        
    // MARK: - Private methods
    
    private func makeChannelIDPredicate(forChannel channel: Channel) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "identifier == '\(channel.identifier)'")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
    
    private func makeChannelMessagesPredicate(forChannel channel: Channel) -> NSCompoundPredicate {
        let predicate = NSPredicate(format: "channel.identifier == '\(channel.identifier)'")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
    }
}
