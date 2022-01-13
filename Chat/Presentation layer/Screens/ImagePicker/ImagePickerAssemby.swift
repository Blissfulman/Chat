//
//  ImagePickerAssemby.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

final class ImagePickerAssemby {
    
    static func assemble(parameters: Parameters) -> UIViewController {
        let presenter = ImagePickerPresenter()
        let imagePickerDataSource = ImagePickerDataSource()
        let interactor = ImagePickerInteractor(
            presenter: presenter,
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
        let didPickImageHandler: (URL) -> Void
    }
}
