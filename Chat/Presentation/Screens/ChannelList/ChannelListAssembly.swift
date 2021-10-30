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
        let interactor = ChannelListInteractor(presenter: presenter)
        let router = ChannelListRouter()
        let viewController = ChannelListViewController(interactor: interactor, router: router)
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
