//
//  ProfileViewControllerTransitioningDelegate.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 02.12.2021.
//

import UIKit

final class ProfileViewControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Private properties
    
    private let presentingStartPoint: CGPoint
    
    // MARK: - Initialization
    
    init(presentingStartPoint: CGPoint) {
        self.presentingStartPoint = presentingStartPoint
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ProfileViewControllerPresentedTransition(presentingStartPoint: presentingStartPoint)
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ProfileViewControllerDismissedTransition(dismissingEndPoint: presentingStartPoint)
    }
}
