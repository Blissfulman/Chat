//
//  UIWindow+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 01.12.2021.
//

import UIKit

extension UIWindow {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) {
            Animator.startTinkoffLogoEmission(self, with: location)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let location = touches.first?.location(in: self) {
            Animator.moveTinkoffLogoEmission(to: location)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        Animator.stopTinkoffLogoEmission()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        Animator.stopTinkoffLogoEmission()
    }
}
