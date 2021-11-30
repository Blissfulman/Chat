//
//  Animator.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.11.2021.
//

import UIKit

struct Animator {
    
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
}
