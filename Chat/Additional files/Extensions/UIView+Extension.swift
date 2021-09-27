//
//  UIView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.09.2021.
//

import UIKit

extension UIView {
    
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
}
