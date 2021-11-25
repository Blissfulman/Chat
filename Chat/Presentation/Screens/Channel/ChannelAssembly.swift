//
//  ChannelAssembly.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation
import UIKit

final class ChannelAssembly {
    
    static func assembly(parameters: Parameters) -> UIViewController {
        let presenter = ChannelPresenter()
        let channelDataSource: ChannelDataSourceProtocol = ChannelDataSource(channel: parameters.channel)
        let interactor = ChannelInteractor(
            presenter: presenter,
            channelDataSource: channelDataSource,
            channel: parameters.channel,
            senderName: parameters.senderName
        )
        let viewController = ChannelViewController(
            interactor: interactor,
            channelDataSource: channelDataSource,
            channelName: parameters.channel.name
        )
        presenter.view = viewController
        return viewController
    }
    
    struct Parameters {
        let channel: Channel
        let senderName: String
    }
}
