//
//  ProfileRouter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import UIKit

protocol ProfileRoutingLogic: AnyObject {
    func navigateToImagePicker(route: ProfileModel.Route.ImagePicker)
    func back(route: ProfileModel.Route.Back)
}

final class ProfileRouter: ProfileRoutingLogic {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    
    // MARK: - ProfileRoutingLogic
    
    func navigateToImagePicker(route: ProfileModel.Route.ImagePicker) {
        let parameters = ImagePickerAssemby.Parameters(didPickImageHandler: route.didPickImageHandler)
        let imagePickerViewController = ImagePickerAssemby.assembly(parameters: parameters)
        viewController?.present(imagePickerViewController, animated: true)
    }
    
    func back(route: ProfileModel.Route.Back) {
        viewController?.dismiss(animated: true)
    }
}
