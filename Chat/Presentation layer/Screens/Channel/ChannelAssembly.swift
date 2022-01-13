//
//  ChannelAssembly.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation
import UIKit

final class ChannelAssembly {
    
    static func assemble(parameters: Parameters) -> UIViewController {
        let presenter = ChannelPresenter()
        let messagesService: MessagesService = ServiceLayer.shared.messagesService(channelID: parameters.channel.id)
        let channelDataSource = ChannelDataSource(
            fetchedResultsController: messagesService.channelFetchedResultsController(forChannel: parameters.channel)
        )
        let interactor = ChannelInteractor(
            presenter: presenter,
            messagesService: ServiceLayer.shared.messagesService(channelID: parameters.channel.id),
            channelDataSource: channelDataSource,
            channel: parameters.channel,
            senderName: parameters.senderName
        )
        let router = ChannelRouter()
        let viewController = ChannelViewController(
            interactor: interactor,
            router: router,
            channelDataSource: channelDataSource,
            channelName: parameters.channel.name
        )
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
    
    struct Parameters {
        let channel: Channel
        let senderName: String
    }
}
