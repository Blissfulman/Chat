//
//  ChannelsService.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 18.11.2021.
//

import Foundation

protocol ChannelsService {
    func setChannelsListener(failureHandler: @escaping (Error) -> Void)
    func addNewChannel(_ channel: Channel)
    func deleteChannel(_ channel: Channel)
}
