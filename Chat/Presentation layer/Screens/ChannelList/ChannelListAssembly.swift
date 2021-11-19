//
//  ChannelListAssembly.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Foundation
import UIKit

final class ChannelListAssembly {
    
    static func assembly() -> UIViewController {
        let presenter = ChannelListPresenter()
        let channelsService: ChannelsService = ServiceLayer.shared.channelsService
        let channelListDataSource = ChannelListDataSource(
            fetchedResultsController: channelsService.channelListFetchedResultsController
        )
        let interactor = ChannelListInteractor(presenter: presenter, channelListDataSource: channelListDataSource)
        let router = ChannelListRouter()
        let viewController = ChannelListViewController(
            interactor: interactor,
            router: router,
            channelListDataSource: channelListDataSource
        )
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
