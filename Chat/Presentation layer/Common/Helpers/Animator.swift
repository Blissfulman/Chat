//
//  Animator.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 30.11.2021.
//

import UIKit

final class Animator {
    
    // MARK: - Static private properties
    
    static private let tinkoffLogoCell: CAEmitterCell = {
        var cell = CAEmitterCell()
        cell.contents = Icons.tinkoffLogo.cgImage
        cell.scale = 0.6
        cell.emissionRange = .pi
        cell.lifetime = 4
        cell.birthRate = 1
        cell.velocity = 200
        cell.yAcceleration = 30
        cell.spin = 0.5
        cell.spinRange = 0.5
        cell.alphaSpeed = -0.8
        return cell
    }()
    
    static private var tinkoffLogoEmissionLayer: CAEmitterLayer = {
        let logoLayer = CAEmitterLayer()
        logoLayer.emitterShape = .point
        logoLayer.beginTime = CACurrentMediaTime()
        logoLayer.timeOffset = CFTimeInterval(Int.random(in: 5...10))
        logoLayer.emitterCells = [tinkoffLogoCell]
        return logoLayer
    }()
    
    // MARK: - Static public methods
    
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
        animatingView.layer.add(animationGroup, forKey: "shakeAnimation")
    }
    
    /// Анимация плавной остановки тряски.
    /// - Parameter animatingView: Анимируемое вью.
    static func stopShake(_ animatingView: UIView) {
        let positionAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.toValue = animatingView.layer.position
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            animatingView.layer.removeAllAnimations()
        }
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation, rotationAnimation]
        animationGroup.duration = 0.5
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animatingView.layer.add(animationGroup, forKey: "stopShakeAnimation")
        CATransaction.commit()
    }
    
    /// Старт анимации испускания гербов Тинькофф.
    /// - Parameters:
    ///   - ownerView: Вью, к которому будет добавлен слой с анимацией.
    ///   - emissionPoint: Точка позиции для анимации.
    static func startTinkoffLogoEmission(_ ownerView: UIView, with emissionPoint: CGPoint) {
        tinkoffLogoEmissionLayer.emitterPosition = emissionPoint
        tinkoffLogoEmissionLayer.birthRate = 12
        ownerView.layer.addSublayer(tinkoffLogoEmissionLayer)
    }
    
    /// Перемещение анимации испускания гербов Тинькофф на новую позицию.
    /// - Parameter emissionPoint: Новая точка позиции для анимации.
    static func moveTinkoffLogoEmission(to emissionPoint: CGPoint) {
        tinkoffLogoEmissionLayer.emitterPosition = emissionPoint
    }
    
    /// Остановка анимации испускания гербов Тинькофф.
    static func stopTinkoffLogoEmission() {
        tinkoffLogoEmissionLayer.birthRate = 0
    }
}
