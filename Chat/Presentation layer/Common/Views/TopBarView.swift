//
//  TopBarView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 23.11.2021.
//

import UIKit

final class TopBarView: UIView {
    
    // MARK: - Private properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.title
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let rightButtonAction: () -> Void
    
    // MARK: - Initialization
    
    init(title: String? = nil, rightButtonTitle: String, rightButtonAction: @escaping () -> Void) {
        self.rightButtonAction = rightButtonAction
        super.init(frame: .zero)
        titleLabel.text = title
        rightButton.setTitle(rightButtonTitle, for: .normal)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setTheme(_ theme: Theme) {
        backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.fontColor
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        backgroundColor = Palette.lightBarColor
        addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel, rightButton)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc
    private func rightButtonTapped() {
        rightButtonAction()
    }
}
