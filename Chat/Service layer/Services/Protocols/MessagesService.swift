//
//  MessagesService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

protocol MessagesService {
    func setMessagesListener(channel: Channel, failureHandler: @escaping (Error) -> Void)
    func addNewMessage(_ message: Message)
}
