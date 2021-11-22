//
//  ImagePickerAssemby.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

final class ImagePickerAssemby {
    
    static func assembly(parameters: Parameters) -> UIViewController {
        let presenter = ImagePickerPresenter()
        let imagePickerDataSource = ImagePickerDataSource()
        let interactor = ImagePickerInteractor(
            presenter: presenter,
//            imagesService: ServiceLayer.shared.imagesService,
            imagePickerDataSource: imagePickerDataSource,
            didPickImageHandler: parameters.didPickImageHandler
        )
        let router = ImagePickerRouter()
        let viewController = ImagePickerViewController(
            interactor: interactor,
            router: router,
            imagePickerDataSource: imagePickerDataSource
        )
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
    
    struct Parameters {
        let didPickImageHandler: (Data) -> Void
    }
}
