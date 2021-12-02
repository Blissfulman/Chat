//
//  ProfileViewControllerTransitions.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 02.12.2021.
//

import UIKit

final class ProfileViewControllerPresentedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Private properties
    
    private let presentingStartPoint: CGPoint
    
    // MARK: - Initialization
    
    init(presentingStartPoint: CGPoint) {
        self.presentingStartPoint = presentingStartPoint
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
            toView.center = presentingStartPoint
            toView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            UIView.animate(
                withDuration: 1.2,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.2,
                options: [.curveEaseInOut],
                animations: {
                    toView.center = containerView.center
                    toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}

final class ProfileViewControllerDismissedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Private properties
    
    private let dismissingEndPoint: CGPoint
    
    // MARK: - Initialization
    
    init(dismissingEndPoint: CGPoint) {
        self.dismissingEndPoint = dismissingEndPoint
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let fromView = transitionContext.view(forKey: .from) {
            containerView.addSubview(fromView)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                fromView.center = self.dismissingEndPoint
                fromView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                fromView.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
