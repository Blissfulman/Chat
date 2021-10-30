//
//  ChannelListPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.10.2021.
//

import Foundation

protocol ChannelListPresentationLogic: AnyObject {
    func presentProfileData(response: ChannelListModel.UpdateProfile.Response)
    func presentChannelList(response: ChannelListModel.ChannelList.Response)
    func presentFetchingChannelsError(response: ChannelListModel.FetchingChannelsError.Response)
}

final class ChannelListPresenter: ChannelListPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ChannelListDisplayLogic?
    
    // MARK: - ChannelListPresentationLogic
    
    func presentProfileData(response: ChannelListModel.UpdateProfile.Response) {
        let viewModel = ChannelListModel.UpdateProfile.ViewModel(
            avatarImageData: response.avatarImageData ?? (Images.noPhoto.jpegData(compressionQuality: 0.5) ?? Data()),
            senderName: response.senderName ?? "No name"
        )
        view?.displayProfileData(viewModel: viewModel)
    }
    
    func presentChannelList(response: ChannelListModel.ChannelList.Response) {
        view?.displayChannelList(viewModel: ChannelListModel.ChannelList.ViewModel(channels: response.channels))
    }
    
    func presentFetchingChannelsError(response: ChannelListModel.FetchingChannelsError.Response) {
        let viewModel = ChannelListModel.FetchingChannelsError.ViewModel(
            title: "Error",
            message: response.error.localizedDescription
        )
        view?.displayFetchingChannelsError(viewModel: viewModel)
    }
}
