//
//  ChannelListRouter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import UIKit

protocol ChannelListRoutingLogic: AnyObject {
    func navigateToSettings(route: ChannelListModel.Route.SettingsScreen)
    func navigateToProfile(route: ChannelListModel.Route.ProfileScreen)
    func navigateToChannel(route: ChannelListModel.Route.ChannelScreen)
}

final class ChannelListRouter: ChannelListRoutingLogic {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    
    // MARK: - ChannelListRoutingLogic
    
    func navigateToSettings(route: ChannelListModel.Route.SettingsScreen) {
        let themesPresenter = ThemesPresenter(didChooseThemeHandler: route.didChooseThemeHandler)
        let themesViewController = ThemesViewController(presenter: themesPresenter)
        themesViewController.modalPresentationStyle = .fullScreen
        viewController?.present(themesViewController, animated: true)
    }
    
    func navigateToProfile(route: ChannelListModel.Route.ProfileScreen) {
        let parameters = ProfileAssembly.Parameters(
            presentingStartPoint: route.presentingStartPoint,
            didChangeProfileHandler: route.didChangeProfileHandler
        )
        let profileViewController = ProfileAssembly.assemble(parameters: parameters)
        profileViewController.modalPresentationStyle = .overFullScreen
        viewController?.present(profileViewController, animated: true)
    }
    
    func navigateToChannel(route: ChannelListModel.Route.ChannelScreen) {
        let parameters = ChannelAssembly.Parameters(channel: route.channel, senderName: route.senderName)
        let channelViewController = ChannelAssembly.assemble(parameters: parameters)
        viewController?.navigationController?.show(channelViewController, sender: self)
    }
}
