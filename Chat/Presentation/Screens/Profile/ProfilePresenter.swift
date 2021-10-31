//
//  ProfilePresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

protocol ProfilePresentationLogic: AnyObject {
    func presentProfile(response: ProfileModel.FetchProfile.Response)
    func presentEditingState(response: ProfileModel.EditingState.Response)
    func presentSavedState(response: ProfileModel.SavedState.Response)
    func updateSaveButtonState(response: ProfileModel.UpdateSaveButtonState.Response)
    func showProgressView(response: ProfileModel.ShowProgressView.Response)
    func hideProgressView(response: ProfileModel.HideProgressView.Response)
    func presentProfileSaved(response: ProfileModel.ProfileSaved.Response)
    func presentSavingProfileError(response: ProfileModel.SavingProfileError.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ProfileDisplayLogic?
    
    // MARK: - ProfilePresentationLogic
    
    func presentProfile(response: ProfileModel.FetchProfile.Response) {
        let viewModel = ProfileModel.FetchProfile.ViewModel(
            fullName: response.fullName, description: response.description,
            avatarImageData: response.avatarImageData ?? (Images.noPhoto.pngData() ?? Data())
        )
        view?.displayProfile(viewModel: viewModel)
    }
    
    func presentEditingState(response: ProfileModel.EditingState.Response) {
        view?.displayEditingState(viewModel: ProfileModel.EditingState.ViewModel())
    }
    
    func presentSavedState(response: ProfileModel.SavedState.Response) {
        view?.displaySavedState(viewModel: ProfileModel.SavedState.ViewModel())
    }
    
    func updateSaveButtonState(response: ProfileModel.UpdateSaveButtonState.Response) {
        view?.updateSaveButtonState(
            viewModel: ProfileModel.UpdateSaveButtonState.ViewModel(isEnabledButton: response.isEnabledButton)
        )
    }
    
    func showProgressView(response: ProfileModel.ShowProgressView.Response) {
        view?.showProgressView(viewModel: ProfileModel.ShowProgressView.ViewModel())
    }
    
    func hideProgressView(response: ProfileModel.HideProgressView.Response) {
        view?.hideProgressView(viewModel: ProfileModel.HideProgressView.ViewModel())
    }
    
    func presentProfileSaved(response: ProfileModel.ProfileSaved.Response) {
        view?.displayProfileSaved(viewModel: ProfileModel.ProfileSaved.ViewModel(title: "Data saved"))
    }
    
    func presentSavingProfileError(response: ProfileModel.SavingProfileError.Response) {
        let viewModel = ProfileModel.SavingProfileError.ViewModel(retryHandler: response.retryHandler)
        view?.displaySavingProfileError(viewModel: viewModel)
    }
}
