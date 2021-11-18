//
//  ChannelsService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import CoreData

protocol ChannelsService {
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые каналы.
    var channelListFetchedResultsController: NSFetchedResultsController<DBChannel> { get }
    
    /// Установка слушателя каналов.
    /// - Parameter failureHandler: Обработчик, вызываемый в случае неудачи при получении каналов. В него возвращается полученная ошибка.
    func setChannelsListener(failureHandler: @escaping (Error) -> Void)
    /// Добавленние нового канала.
    /// - Parameter channel: Добавляемый канал.
    func addNewChannel(_ channel: Channel)
    /// Удаление канала.
    /// - Parameter channel: Удаляемый канал.
    func deleteChannel(_ channel: Channel)
}
