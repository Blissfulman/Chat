//
//  ImagePickerInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

protocol ImagePickerBusinessLogic {
    func didPickImage(request: ImagePickerModel.PickImage.Request)
}

final class ImagePickerInteractor: ImagePickerBusinessLogic {
    
    // MARK: - Private properties
    
    private let presenter: ImagePickerPresentationLogic
//    private let imagesService: ImagesService
    private let imagePickerDataSource: ImagePickerDataSourceProtocol
    private let didPickImageHandler: (Data) -> Void
    
    // MARK: - Initialization
    
    init(
        presenter: ImagePickerPresentationLogic,
//        imagesService: ImagesService = ServiceLayer.shared.imagesService,
        imagePickerDataSource: ImagePickerDataSourceProtocol,
        didPickImageHandler: @escaping (Data) -> Void
    ) {
        self.presenter = presenter
//        self.imagesService = imagesService
        self.imagePickerDataSource = imagePickerDataSource
        self.didPickImageHandler = didPickImageHandler
    }
    
    // MARK: - ImagePickerBusinessLogic
    
    func didPickImage(request: ImagePickerModel.PickImage.Request) {
        if let imageData = imagePickerDataSource.imageData(at: request.indexPath) {
            didPickImageHandler(imageData)
            presenter.presentDidPickImage(request: ImagePickerModel.PickImage.Response(imageData: imageData))
        }
    }
}
