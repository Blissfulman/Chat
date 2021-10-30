//
//  NewMessageTextField.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.10.2021.
//

import UIKit

final class NewMessageTextField: UITextField {
    
    // MARK: - Private properties
    
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    // MARK: - Override methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        font = Fonts.newMessageTextField
        backgroundColor = .white
        layer.borderWidth = 0.5
        layer.borderColor = Palette.textFieldBorderGray?.cgColor
        placeholder = "Your message here..."
    }
}
