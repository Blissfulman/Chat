//
//  ProfileAssembly.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation
import UIKit

final class ProfileAssembly {
    
    static func assemble(parameters: Parameters) -> UIViewController {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            presenter: presenter,
            didChangeProfileHandler: parameters.didChangeProfileHandler
        )
        let router = ProfileRouter()
        let transitioningDelegate = ProfileViewControllerTransitioningDelegate(
            presentingStartPoint: parameters.presentingStartPoint
        )
        let viewController = ProfileViewController(
            interactor: interactor,
            router: router,
            transitioningDelegate: transitioningDelegate
        )
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
    
    struct Parameters {
        let presentingStartPoint: CGPoint
        let didChangeProfileHandler: (Profile) -> Void
    }
}
