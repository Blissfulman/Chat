//
//  ProfileInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation

protocol ProfileBusinessLogic: AnyObject {
    func fetchProfile(request: ProfileModel.FetchProfile.Request)
    func editProfileButtonTapped(request: ProfileModel.EditProfileButtonTapped.Request)
    func requestEditingAvatarAlert(request: ProfileModel.EditingAvatarAlert.Request)
    func didSelectNewAvatar(request: ProfileModel.DidSelectNewAvatar.Request)
    func textFieldsEditingChanged(request: ProfileModel.TextFieldsEditingChanged.Request)
    func rollbackCurrentViewData(request: ProfileModel.RollbackCurrentViewData.Request)
    func requestSavingProfileAlert(request: ProfileModel.SavingProfileAlert.Request)
    func saveProfile(request: ProfileModel.SaveProfile.Request)
}

final class ProfileInteractor: ProfileBusinessLogic {
    
    // MARK: - Nested types
    
    private enum State {
        case saved
        case editing
        case edited
    }
    
    // MARK: - Private properties
    
    private let presenter: ProfilePresentationLogic
    private let didChangeProfileHandler: ((Profile) -> Void)
    private var asyncDataManager: AsyncDataManagerProtocol = AsyncDataManager(asyncHandlerType: .gcd)
    // Хранение задачи сохранения данных необходимо для возможности её повторения
    private var savingTask: ((Profile, ProfileModel.SavingVariant) -> Void)?
    private var isChangedAvatar = false
    /// Сохранённое состояние данных вью для возможности возврата к этому состоянию в случае нажатия кнопки "Cancel".
    private var savedViewData: (fullName: String?, description: String?, avatarImageData: Data?)
    private var state: State = .saved {
        didSet {
            switch state {
            case .saved:
                presenter.presentSavedState(response: ProfileModel.SavedState.Response())
            case .editing:
                if oldValue == .saved {
                    presenter.presentEditingState(response: ProfileModel.EditingState.Response())
                } else {
                    updateSaveButtonState()
                }
            case .edited:
                updateSaveButtonState()
            }
        }
    }
    
    // MARK: - Initialization
    
    init(presenter: ProfilePresentationLogic, didChangeProfileHandler: @escaping ((Profile) -> Void)) {
        self.presenter = presenter
        self.didChangeProfileHandler = didChangeProfileHandler
    }
    
    // MARK: - ProfileBusinessLogic
    
    func fetchProfile(request: ProfileModel.FetchProfile.Request) {
        asyncDataManager.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let response = ProfileModel.FetchProfile.Response(
                    fullName: profile?.fullName,
                    description: profile?.description,
                    avatarImageData: profile?.avatarData
                )
                self?.presenter.presentProfile(response: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func editProfileButtonTapped(request: ProfileModel.EditProfileButtonTapped.Request) {
        // Сохранение текущего состояния вью для возможности возврата к этому состоянию в случае нажатия кнопки "Cancel".
        savedViewData.fullName = request.fullName
        savedViewData.description = request.description
        savedViewData.avatarImageData = request.avatarImageData
        isChangedAvatar = false
        state = .editing
    }
    
    func requestEditingAvatarAlert(request: ProfileModel.EditingAvatarAlert.Request) {
        presenter.presentEditingAvatarAlert(response: ProfileModel.EditingAvatarAlert.Response())
    }
    
    func didSelectNewAvatar(request: ProfileModel.DidSelectNewAvatar.Request) {
        isChangedAvatar = true
        state = .edited
    }
    
    func textFieldsEditingChanged(request: ProfileModel.TextFieldsEditingChanged.Request) {
        guard !isChangedAvatar else { return }
        if (request.fullName == savedViewData.fullName) && (request.description == savedViewData.description) {
            state = .editing
        } else {
            state = .edited
        }
    }
    
    func rollbackCurrentViewData(request: ProfileModel.RollbackCurrentViewData.Request) {
        let response = ProfileModel.FetchProfile.Response(
            fullName: savedViewData.fullName,
            description: savedViewData.description,
            avatarImageData: savedViewData.avatarImageData
        )
        presenter.presentProfile(response: response)
        state = .saved
    }
    
    func requestSavingProfileAlert(request: ProfileModel.SavingProfileAlert.Request) {
        presenter.presentSavingProfileAlert(response: ProfileModel.SavingProfileAlert.Response())
    }
    
    func saveProfile(request: ProfileModel.SaveProfile.Request) {
        let profile = Profile(
            fullName: request.fullName ?? "",
            description: request.description ?? "",
            avatarData: request.avatarImageData
        )
        
        savingTask = { [weak self, asyncDataManager, didChangeProfileHandler] profile, savingVariant in
            guard let self = self else {
                // Если экран уже закрыт, то просто совершается ещё одна попытка сохранить профиль
                asyncDataManager.saveProfile(profile: profile) { result in
                    if case .success = result { didChangeProfileHandler(profile) }
                }
                return
            }
            self.presenter.showProgressView(response: ProfileModel.ShowProgressView.Response())
            
            asyncDataManager.saveProfile(profile: profile) { result in
                self.presenter.hideProgressView(response: ProfileModel.HideProgressView.Response())
                switch result {
                case .success:
                    self.state = .saved
                    self.presenter.presentProfileSavedAlert(response: ProfileModel.ProfileSavedAlert.Response())
                    didChangeProfileHandler(profile)
                case .failure(let error):
                    print(error.localizedDescription)
                    let response = ProfileModel.SavingProfileError.Response(
                        retryHandler: { self.savingTask?(profile, savingVariant) }
                    )
                    self.presenter.presentSavingProfileError(response: response)
                }
            }
        }
        if request.savingVariant == .gcd {
            asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
        } else {
            asyncDataManager = AsyncDataManager(asyncHandlerType: .operations)
        }
        savingTask?(profile, request.savingVariant)
    }
    
    // MARK: - Private methods
    
    private func updateSaveButtonState() {
        let isEnabledButton = isChangedAvatar || state == .edited
        let response = ProfileModel.UpdateSaveButtonState.Response(isEnabledButton: isEnabledButton)
        presenter.updateSaveButtonState(response: response)
    }
}
