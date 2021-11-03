//
//  ProfileViewController+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 01.11.2021.
//

import UIKit

extension ProfileViewController {
    
    func editAvatarAlert(
        title: String,
        galleryAction: @escaping () -> Void,
        cameraAction: @escaping () -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Select from the gallery", style: .default) { _ in
            galleryAction()
        }
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { _ in
            cameraAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func savingProfileAlertController(
        saveWithGCDAction: @escaping () -> Void,
        saveWithOperationsAction: @escaping () -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveWithGCDAction = UIAlertAction(title: "Save with GCD", style: .default) { _ in
            saveWithGCDAction()
        }
        let saveWithOperationsAction = UIAlertAction(title: "Save with Operations", style: .default) { _ in
            saveWithOperationsAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(saveWithGCDAction)
        alertController.addAction(saveWithOperationsAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func savingErrorAlert(
        title: String?,
        message: String?,
        retryHandler: @escaping () -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
        let retryAction = UIAlertAction(title: "Repeat", style: .default) { _ in
            retryHandler()
        }
        alertController.addAction(okAction)
        alertController.addAction(retryAction)
        alertController.preferredAction = retryAction
        return alertController
    }
}
