//
//  ImegePickerRouter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

protocol ImagePickerRoutingLogic {
    func back()
}

final class ImagePickerRouter: ImagePickerRoutingLogic {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    
    // MARK: - ImagePickerRoutingLogic
    
    func back() {
        viewController?.dismiss(animated: true)
    }
}
