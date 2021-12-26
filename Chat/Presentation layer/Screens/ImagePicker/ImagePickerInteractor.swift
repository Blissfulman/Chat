//
//  ImagePickerInteractor.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import Foundation

protocol ImagePickerBusinessLogic {
    func setupTheme(request: ImagePickerModel.SetupTheme.Request)
    func fetchImages(request: ImagePickerModel.FetchImages.Request)
    func fetchMoreImages(request: ImagePickerModel.FetchMoreImages.Request)
    func didPickImage(request: ImagePickerModel.PickImage.Request)
}

final class ImagePickerInteractor: ImagePickerBusinessLogic {
    
    // MARK: - Nested types
    
    enum Constants {
        static let itemsPerPage = 50
    }
    
    // MARK: - Private properties
    
    private let presenter: ImagePickerPresentationLogic
    private let settingsService: SettingsService
    private let imagesService: ImagesService
    private let imagePickerDataSource: ImagePickerDataSourceProtocol
    private let didPickImageHandler: (URL) -> Void
    private var query = ""
    private var fetchedPages = 0
    
    // MARK: - Initialization
    
    init(
        presenter: ImagePickerPresentationLogic,
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        imagesService: ImagesService = ServiceLayer.shared.imagesService,
        imagePickerDataSource: ImagePickerDataSourceProtocol,
        didPickImageHandler: @escaping (URL) -> Void
    ) {
        self.presenter = presenter
        self.settingsService = settingsService
        self.imagesService = imagesService
        self.imagePickerDataSource = imagePickerDataSource
        self.didPickImageHandler = didPickImageHandler
    }
    
    // MARK: - ImagePickerBusinessLogic
    
    func setupTheme(request: ImagePickerModel.SetupTheme.Request) {
        settingsService.getTheme { [weak self] theme in
            self?.presenter.presentTheme(response: ImagePickerModel.SetupTheme.Response(theme: theme))
        }
    }
    
    func fetchImages(request: ImagePickerModel.FetchImages.Request) {
        query = request.query
        imagesService.fetchImages(query: query, itemsPerPage: Constants.itemsPerPage, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(imagesResponse):
                self.fetchedPages = 1
                self.imagePickerDataSource.updateData(imageItems: imagesResponse.imageItems)
                self.presenter.presentImages(response: ImagePickerModel.FetchImages.Response())
            case let .failure(error):
                DebugLogger.log(error.localizedDescription)
            }
        }
    }
    
    func fetchMoreImages(request: ImagePickerModel.FetchMoreImages.Request) {
        guard request.indexPath.row == (fetchedPages * Constants.itemsPerPage - 20) else { return }
        
        imagesService.fetchImages(
            query: query,
            itemsPerPage: Constants.itemsPerPage,
            page: fetchedPages + 1
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(imagesResponse):
                self.fetchedPages += 1
                self.imagePickerDataSource.updateData(imageItems: imagesResponse.imageItems)
            case let .failure(error):
                DebugLogger.log(error.localizedDescription)
            }
        }
    }
    
    func didPickImage(request: ImagePickerModel.PickImage.Request) {
        if let imageURL = imagePickerDataSource.imageItem(at: request.indexPath).webformatURL {
            didPickImageHandler(imageURL)
            presenter.presentDidPickImage(response: ImagePickerModel.PickImage.Response())
        }
    }
}
