//
//  ProfileRouter.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import UIKit

protocol ProfileRoutingLogic: AnyObject {
    func dismiss()
}

final class ProfileRouter: ProfileRoutingLogic {
    
    // MARK: - Public properties
    
    weak var viewController: UIViewController?
    
    // MARK: - ChannelListRoutingLogic
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
