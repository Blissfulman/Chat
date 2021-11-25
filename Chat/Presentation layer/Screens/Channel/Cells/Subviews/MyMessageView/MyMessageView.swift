//
//  MyMessageView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

import UIKit

final class MyMessageView: UIView {
    
    // MARK: - Private properties
    
    private lazy var shapeImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleToFill
        imageView.image = Images.myMessageShape
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFill
        imageView.setCornerRadius(8)
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellDate
        label.textColor = UIColor.black.withAlphaComponent(0.25)
        label.textAlignment = .right
        return label
    }()
    
    private let viewModel: MyMessageViewModelProtocol
    
    // MARK: - Initialization
    
    init(frame: CGRect = .zero, viewModel: MyMessageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        prepareForAutoLayout()
        addSubview(shapeImageView)
        addSubview(stackView)
        stackView.addArrangedSubviews(
            viewModel.isImageMessage ? messageImageView : messageLabel,
            dateLabel
        )
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            shapeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            shapeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            shapeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            shapeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: shapeImageView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: shapeImageView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureUI() {
        if viewModel.isImageMessage,
           let messageURL = viewModel.messageURL {
            messageImageView.setImage(with: messageURL, stubImage: Images.noImageAvailable)
        } else {
            messageLabel.text = viewModel.text
        }
        dateLabel.text = viewModel.date
        shapeImageView.setMessageShapeShadow()
    }
}
