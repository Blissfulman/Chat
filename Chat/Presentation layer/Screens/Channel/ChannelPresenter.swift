//
//  ChannelPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

protocol ChannelPresentationLogic {
    func presentTheme(response: ChannelModel.SetupTheme.Response)
    func presentFetchingMessagesError(response: ChannelModel.FetchingMessagesError.Response)
    func presentSendMessage(response: ChannelModel.SendMessage.Response)
}

final class ChannelPresenter: ChannelPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ChannelDisplayLogic?
    
    // MARK: - ChannelPresentationLogic
    
    func presentTheme(response: ChannelModel.SetupTheme.Response) {
        view?.displayTheme(viewModel: ChannelModel.SetupTheme.ViewModel(theme: response.theme))
    }
    
    func presentFetchingMessagesError(response: ChannelModel.FetchingMessagesError.Response) {
        let viewModel = ChannelModel.FetchingMessagesError.ViewModel(
            title: "Error",
            message: response.error.localizedDescription
        )
        view?.displayFetchingMessagesError(viewModel: viewModel)
    }
    
    func presentSendMessage(response: ChannelModel.SendMessage.Response) {
        view?.displaySendMessage(viewModel: ChannelModel.SendMessage.ViewModel())
    }
}
