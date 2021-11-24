//
//  ImagePickerInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

protocol ImagePickerBusinessLogic {
    func fetchImages(request: ImagePickerModel.FetchImages.Request)
    func didPickImage(request: ImagePickerModel.PickImage.Request)
}

final class ImagePickerInteractor: ImagePickerBusinessLogic {
    
    // MARK: - Nested types
    
    enum Constants {
        static let itemsPerPage = 30
    }
    
    // MARK: - Private properties
    
    private let presenter: ImagePickerPresentationLogic
    private let imagesService: ImagesService
    private let imagePickerDataSource: ImagePickerDataSourceProtocol
    private let didPickImageHandler: (URL) -> Void
    private var fetchedPages = 0
    
    // MARK: - Initialization
    
    init(
        presenter: ImagePickerPresentationLogic,
        imagesService: ImagesService = ServiceLayer.shared.imagesService,
        imagePickerDataSource: ImagePickerDataSourceProtocol,
        didPickImageHandler: @escaping (URL) -> Void
    ) {
        self.presenter = presenter
        self.imagesService = imagesService
        self.imagePickerDataSource = imagePickerDataSource
        self.didPickImageHandler = didPickImageHandler
    }
    
    // MARK: - ImagePickerBusinessLogic
    
    func fetchImages(request: ImagePickerModel.FetchImages.Request) {
        imagesService.fetchImages(query: "cats", itemsPerPage: Constants.itemsPerPage, page: 1) { [weak self] result in
            switch result {
            case let .success(imagesResponse):
                self?.imagePickerDataSource.updateData(imageItems: imagesResponse.imageItems)
            case let .failure(error):
                DebugLogger.log(error.localizedDescription)
            }
        }
    }
    
    func didPickImage(request: ImagePickerModel.PickImage.Request) {
        if let imageURL = imagePickerDataSource.imageItem(at: request.indexPath).webformatURL {
            didPickImageHandler(imageURL)
            presenter.presentDidPickImage(request: ImagePickerModel.PickImage.Response())
        }
    }
}
