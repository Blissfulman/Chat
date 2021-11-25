//
//  MessagesService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import CoreData

protocol MessagesService {
    /// Экземпляр `NSFetchedResultsController`, отслеживающий сохранённые сообщения указанного канала.
    /// - Parameter channel: Канал, сообщения которого контроллер будет отслеживать.
    func channelFetchedResultsController(forChannel channel: Channel) -> NSFetchedResultsController<DBMessage>
    /// Установка слушателя сообщений канала.
    /// - Parameters:
    ///   - channel: Канал, cообщения которого будут слушаться.
    ///   - failureHandler: Обработчик, вызываемый в случае неудачи при получении каналов. В него возвращается полученная ошибка.
    func setMessagesListener(channel: Channel, failureHandler: @escaping (Error) -> Void)
    /// Добавленние нового сообщения.
    /// - Parameter message: Добавляемое сообщение.
    func addNewMessage(_ message: Message)
}
