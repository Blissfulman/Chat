//
//  ContentManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import CoreData

/// Менеджер контента приложения.
protocol ContentManager {
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые каналы.
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> { get }
    
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые сообщения указанного канала.
    /// - Parameter channel: Канал, чьи сообщения контроллер будет отслеживать.
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage>
    /// Сохранение всех несохранённых данных.
    func saveData()
    /// Обновление данных о каналах.
    /// - Parameter snapshotChannels: Снимок изменений каналов.
    func updateChannels(_ snapshotChannels: SnapshotObjects<Channel>)
    /// Обновление данных о сообщениях в канале.
    /// - Parameters:
    ///   - snapshotMessages: Снимок изменений сообщений.
    ///   - channel: Канал, к которому эти сообщения относятся.
    func updateMessages(_ snapshotMessages: SnapshotObjects<Message>, forChannel channel: Channel)
}
