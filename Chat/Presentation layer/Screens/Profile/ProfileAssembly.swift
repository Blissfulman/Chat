//
//  ProfileAssembly.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.10.2021.
//

import Foundation
import UIKit

final class ProfileAssembly {
    
    static func assembly(parameters: Parameters) -> UIViewController {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            presenter: presenter,
            didChangeProfileHandler: parameters.didChangeProfileHandler
        )
        let router = ProfileRouter()
        let viewController = ProfileViewController(interactor: interactor, router: router)
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
    
    struct Parameters {
        let didChangeProfileHandler: (Profile) -> Void
    }
}
