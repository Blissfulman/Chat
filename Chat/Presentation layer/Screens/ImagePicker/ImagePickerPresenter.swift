//
//  ImagePickerPresenter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

protocol ImagePickerPresentationLogic {
    func presentDidPickImage(request: ImagePickerModel.PickImage.Response)
}

final class ImagePickerPresenter: ImagePickerPresentationLogic {
    
    // MARK: - Public properties
    
    weak var view: ImagePickerDisplayLogic?
    
    // MARK: - ImagePickerPresentationLogic
    
    func presentDidPickImage(request: ImagePickerModel.PickImage.Response) {
        view?.displayDidPickImage(request: ImagePickerModel.PickImage.ViewModel())
    }
}
