//
//  ChannelListPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Foundation

protocol ChannelListPresentationLogic: AnyObject {
    func presentProfileData(response: ChannelListModel.UpdateProfile.Response)
    func presentFetchingChannelsError(response: ChannelListModel.FetchingChannelsError.Response)
    func presentAddChannelAlert(response: ChannelListModel.AddChannelAlert.Response)
    func presentSelectedChannel(response: ChannelListModel.OpenChannel.Response)
}

final class ChannelListPresenter: ChannelListPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ChannelListDisplayLogic?
    
    // MARK: - ChannelListPresentationLogic
    
    func presentProfileData(response: ChannelListModel.UpdateProfile.Response) {
        let viewModel = ChannelListModel.UpdateProfile.ViewModel(
            avatarImageData: response.avatarImageData ?? (Images.noPhoto.jpegData(compressionQuality: 0.5) ?? Data())
        )
        view?.displayProfileData(viewModel: viewModel)
    }
    
    func presentFetchingChannelsError(response: ChannelListModel.FetchingChannelsError.Response) {
        let viewModel = ChannelListModel.FetchingChannelsError.ViewModel(
            title: "Error",
            message: response.error.localizedDescription
        )
        view?.displayFetchingChannelsError(viewModel: viewModel)
    }
    
    func presentAddChannelAlert(response: ChannelListModel.AddChannelAlert.Response) {
        view?.displayAddChannelAlert(viewModel: ChannelListModel.AddChannelAlert.ViewModel(title: "Input channel name"))
    }
    
    func presentSelectedChannel(response: ChannelListModel.OpenChannel.Response) {
        let viewModel = ChannelListModel.OpenChannel.ViewModel(
            route: ChannelListModel.Route.ChannelScreen(
                channel: response.channel,
                senderName: response.senderName ?? "No name"
            )
        )
        view?.displaySelectedChannel(viewModel: viewModel)
    }
}
