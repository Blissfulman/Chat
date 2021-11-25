//
//  ImagePickerPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

protocol ImagePickerPresentationLogic {
    func presentTheme(response: ImagePickerModel.SetupTheme.Response)
    func presentImages(response: ImagePickerModel.FetchImages.Response)
    func presentDidPickImage(response: ImagePickerModel.PickImage.Response)
}

final class ImagePickerPresenter: ImagePickerPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ImagePickerDisplayLogic?
    
    // MARK: - ImagePickerPresentationLogic
    
    func presentTheme(response: ImagePickerModel.SetupTheme.Response) {
        view?.displayTheme(viewModel: ImagePickerModel.SetupTheme.ViewModel(theme: response.theme))
    }
    
    func presentImages(response: ImagePickerModel.FetchImages.Response) {
        view?.displayImages(viewModel: ImagePickerModel.FetchImages.ViewModel())
    }
    
    func presentDidPickImage(response: ImagePickerModel.PickImage.Response) {
        view?.displayDidPickImage(viewModel: ImagePickerModel.PickImage.ViewModel())
    }
}
