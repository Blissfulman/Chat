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
        let themesViewController = ThemesViewController(didChooseThemeHandler: route.didChooseThemeHandler)
        themesViewController.modalPresentationStyle = .fullScreen
        viewController?.present(themesViewController, animated: true)
    }
    
    func navigateToProfile(route: ChannelListModel.Route.ProfileScreen) {
        let profileViewController = ProfileViewController(didChangeProfileHandler: route.didChangeProfileHandler)
        viewController?.present(profileViewController, animated: true)
    }
    
    func navigateToChannel(route: ChannelListModel.Route.ChannelScreen) {
        let channelViewController = ChannelViewController(channel: route.channel, senderName: route.senderName)
        viewController?.navigationController?.show(channelViewController, sender: self)
    }
}
