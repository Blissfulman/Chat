//
//  ChannelRouter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import UIKit

protocol ChannelRoutingLogic: AnyObject {
    func navigateToImagePicker(route: ChannelModel.Route.ImagePicker)
}

final class ChannelRouter: ChannelRoutingLogic {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    
    // MARK: - ChannelRoutingLogic
    
    func navigateToImagePicker(route: ChannelModel.Route.ImagePicker) {
        let parameters = ImagePickerAssemby.Parameters(didPickImageHandler: route.didPickImageHandler)
        let imagePickerViewController = ImagePickerAssemby.assembly(parameters: parameters)
        viewController?.present(imagePickerViewController, animated: true)
    }
}
