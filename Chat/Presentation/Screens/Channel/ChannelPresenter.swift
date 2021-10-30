//
//  ChannelPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

protocol ChannelPresentationLogic: AnyObject {
    func presentTheme(response: ChannelModel.FetchTheme.Response)
    func presentMessages(response: ChannelModel.FetchMessages.Response)
    func presentFetchingMessagesError(response: ChannelModel.FetchingMessagesError.Response)
}

final class ChannelPresenter: ChannelPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ChannelDisplayLogic?
    
    // MARK: - ChannelPresentationLogic
    
    func presentTheme(response: ChannelModel.FetchTheme.Response) {
        view?.displayTheme(viewModel: ChannelModel.FetchTheme.ViewModel(theme: response.theme))
    }
    
    func presentMessages(response: ChannelModel.FetchMessages.Response) {
        view?.displayMessages(viewModel: ChannelModel.FetchMessages.ViewModel(messages: response.messages))
    }
    
    func presentFetchingMessagesError(response: ChannelModel.FetchingMessagesError.Response) {
        let viewModel = ChannelModel.FetchingMessagesError.ViewModel(
            title: "Error",
            message: response.error.localizedDescription
        )
        view?.displayFetchingMessagesError(viewModel: viewModel)
    }
}
