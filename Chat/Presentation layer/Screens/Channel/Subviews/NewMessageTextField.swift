//
//  NewMessageTextField.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.10.2021.
//

import UIKit

final class NewMessageTextField: UITextField {
    
    // MARK: - Private properties
    
    private var sendMessageButtonAction: ((String?) -> Void)?
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 45)
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setImage(Icons.sendMessage, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Override properties
    
    override var text: String? {
        didSet {
            editingChanged()
        }
    }
    
    // MARK: - Initialization
    
    convenience init(sendMessageButtonAction: @escaping (String?) -> Void) {
        self.init(frame: .zero)
        self.sendMessageButtonAction = sendMessageButtonAction
        setupUI()
        setupLayout()
        configureUI()
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
    
    private func setupUI() {
        prepareForAutoLayout()
        addSubview(sendMessageButton)
    }
    
    private func setupLayout() {
        sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        sendMessageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func configureUI() {
        font = Fonts.newMessageTextField
        backgroundColor = .white
        layer.borderWidth = 0.5
        layer.borderColor = Palette.textFieldBorderGray?.cgColor
        placeholder = "Your message here..."
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc
    private func editingChanged() {
        if let text = text, !text.isEmpty {
            sendMessageButton.isHidden = false
        } else {
            sendMessageButton.isHidden = true
        }
    }
    
    @objc
    private func sendMessageButtonTapped() {
        sendMessageButtonAction?(text)
    }
}
