//
//  UIView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.09.2021.
//

import UIKit

extension UIView {
    
    @discardableResult
    func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    /// Устанавливает переданный радиус скругления всех углов (по кривой суперэллипса).
    /// - Parameter value: Значение радиуса.
    func setCornerRadius(_ value: CGFloat) {
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        layer.cornerRadius = value
        clipsToBounds = true
    }
    
    /// Округляет вью, устанавливая радиус скругления равным половине ширины.
    func round() {
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
    
    /// Устанавливает переданный радиус скругления указанных углов (по кривой суперэллипса).
    /// - Parameters:
    ///   - corners: Скругляемые углы.
    ///   - radius: Значение радиуса.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        setCornerRadius(radius)
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    /// Устанавливает тень для фигуры сообщения.
    func setMessageShapeShadow() {
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
    }
    
    // MARK: - Animations
    
    /// Анимация плавного появления.
    /// - Parameters:
    ///   - fromValue: Изначальное значение параметра `alpha` (по умолчанию равно `0`).
    ///   - toValue: Конечное значение параметра `alpha` (по умолчанию равно `1`).
    ///   - duration: Длительность анимации.
    ///   - completion: Блок, выполняемый после окончания анимации.
    func appear(fromValue: CGFloat = 0, toValue: CGFloat = 1, duration: Double, completion: (() -> Void)? = nil) {
        isHidden = false
        alpha = fromValue
        UIView.animate(withDuration: duration) {
            self.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                self.alpha = toValue
                completion?()
            }
        }
    }
    
    /// Анимация плавного исчезновения.
    /// - Parameters:
    ///   - fromValue: Изначальное значение параметра `alpha` (по умолчанию равно `1`).
    ///   - toValue: Конечное значение параметра `alpha` (по умолчанию равно `0`).
    ///   - duration: Длительность анимации.
    ///   - completion: Блок, выполняемый после окончания анимации.
    func disappear(fromValue: CGFloat = 1, toValue: CGFloat = 0, duration: Double, completion: (() -> Void)? = nil) {
        alpha = fromValue
        UIView.animate(withDuration: duration) {
            self.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                self.alpha = toValue
                self.isHidden = true
                completion?()
            }
        }
    }
}
