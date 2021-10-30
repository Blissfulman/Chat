//
//  PartnerMessageView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.10.2021.
//

import UIKit

final class PartnerMessageView: UIView {
    
    // MARK: - Nested types
    
    struct Model {
        let authorName: String
        let text: String
        let date: String
    }
    
    // MARK: - Private properties
    
    private lazy var shapeImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleToFill
        imageView.image = Images.partnerMessageShape
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellAuthorName
        label.textColor = Palette.authorNameMessageColor
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellDate
        label.textColor = UIColor.black.withAlphaComponent(0.25)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    
    init(frame: CGRect, model: Model) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        configureUI(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        prepareForAutoLayout()
        addSubview(shapeImageView)
        addSubview(stackView)
        stackView.addArrangedSubviews(authorNameLabel, messageLabel, dateLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            shapeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            shapeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            shapeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            shapeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: shapeImageView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: shapeImageView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureUI(model: Model) {
        authorNameLabel.text = model.authorName
        messageLabel.text = model.text
        dateLabel.text = model.date
        shapeImageView.setMessageShapeShadow()
    }
}
