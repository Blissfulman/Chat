//
//  ProfileFilledButton.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.10.2021.
//

import UIKit

final class ProfileFilledButton: UIButton {
    
    // MARK: - Override properties
    
    override var isEnabled: Bool {
        didSet {
            setTitleColor(isEnabled ? Palette.buttonTitleBlue : .gray, for: .normal)
        }
    }
    
    // MARK: - Initialization
    
    convenience init(withTitle title: String) {
        self.init()
        setTitle(title, for: .normal)
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        backgroundColor = Palette.lightBarColor
        titleLabel?.font = Fonts.buttonTitle
        setTitleColor(Palette.buttonTitleBlue, for: .normal)
        setCornerRadius(14)
    }
}
