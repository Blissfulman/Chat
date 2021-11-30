//
//  Animator.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.11.2021.
//

import UIKit

final class Animator {
    
    /// Анимация плавного появления.
    /// - Parameters:
    ///   - animatingView: Анимируемое вью.
    ///   - fromValue: Изначальное значение параметра `alpha` (по умолчанию равно `0`).
    ///   - toValue: Конечное значение параметра `alpha` (по умолчанию равно `1`).
    ///   - duration: Длительность анимации.
    ///   - completion: Блок, выполняемый после окончания анимации.
    static func appear(
        _ animatingView: UIView,
        fromValue: CGFloat = 0,
        toValue: CGFloat = 1,
        duration: Double,
        completion: (() -> Void)? = nil
    ) {
        animatingView.isHidden = false
        animatingView.alpha = fromValue
        UIView.animate(withDuration: duration) {
            animatingView.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                animatingView.alpha = toValue
                completion?()
            }
        }
    }
    
    /// Анимация плавного исчезновения.
    /// - Parameters:
    ///   - animatingView: Анимируемое вью.
    ///   - fromValue: Изначальное значение параметра `alpha` (по умолчанию равно `1`).
    ///   - toValue: Конечное значение параметра `alpha` (по умолчанию равно `0`).
    ///   - duration: Длительность анимации.
    ///   - completion: Блок, выполняемый после окончания анимации.
    static func disappear(
        _ animatingView: UIView,
        fromValue: CGFloat = 1,
        toValue: CGFloat = 0,
        duration: Double,
        completion: (() -> Void)? = nil
    ) {
        animatingView.alpha = fromValue
        UIView.animate(withDuration: duration) {
            animatingView.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                animatingView.alpha = toValue
                animatingView.isHidden = true
                completion?()
            }
        }
    }
    
    /// Анимация тряски.
    /// - Parameter animatingView: Анимируемое вью.
    static func shake(_ animatingView: UIView) {
        let positionAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.values = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: -5, y: -5),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 5),
            CGPoint(x: 0, y: 0)
        ]
        
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        // Установил угол поворота в 9 градусов, т.к. большая кнопка слишком сильно тряслась
        rotationAnimation.values = [0, -Float.pi / 20, 0, Float.pi / 20, 0]
        
        [positionAnimation, rotationAnimation].forEach {
            $0.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            $0.isAdditive = true
        }
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [positionAnimation, rotationAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animatingView.layer.add(animationGroup, forKey: "shakeAnimation")
    }
    
    /// Анимация плавной остановки тряски.
    /// - Parameter animatingView: Анимируемое вью.
    static func stopShake(_ animatingView: UIView) {
        let positionAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.toValue = animatingView.layer.position
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 0

        let animationGroup = CAAnimationGroup()
        animationGroup.delegate = StopShakeAnimationDelegate(animatingView: animatingView)
        animationGroup.animations = [positionAnimation, rotationAnimation]
        animationGroup.duration = 0.5
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animatingView.layer.add(animationGroup, forKey: "stopShakeAnimation")
    }
}

// MARK: - StopShakeAnimationDelegate

private final class StopShakeAnimationDelegate: NSObject, CAAnimationDelegate {
    
    private weak var animatingView: UIView?
    
    init(animatingView: UIView) {
        self.animatingView = animatingView
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animatingView?.layer.removeAllAnimations()
    }
}
