//
//  ConversationCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import UIKit

protocol ConversationCellConfiguration {
    var name: String? { get set }
    var message: Date? { get set }
    var date: String? { get set }
    var isOnline: Bool { get set }
    var hasUnreadMessage: Bool { get set }
}

final class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    // MARK: - Public properties
    
    var name: String?
    var message: Date?
    var date: String?
    var isOnline = false
    var hasUnreadMessage = false
    
    // MARK: - Private properties
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private var secondStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private var thirdStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.spacing = 6
        return stackView
    }()
    
    private var dateStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.alignment = .center
        stackView.spacing = 9
        return stackView
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private var fullNameLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.conversationCellName
        label.text = "Johnny Watson"
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.conversationCellDate
        label.textColor = Palette.labelGray
        label.text = "Yesterday"
        return label
    }()
    
    private var arrowImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Icons.arrowRight
        return imageView
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.conversationCellReadMessage
        label.textColor = Palette.labelGray
        label.numberOfLines = 2
        label.text = "Dolore veniam Lorem occaecat veniam irure laborum est amet."
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        avatarImageView.image = Images.noPhoto
        fullNameLabel.text = nil
        dateLabel.text = nil
        messageLabel.text = nil
        messageLabel.font = Fonts.conversationCellReadMessage
    }
    
    // MARK: - Public methods
    
    func configure(with conversation: Conversation) {
        if let avatarData = conversation.avatarData {
            avatarImageView.image = UIImage(data: avatarData)
        }
        fullNameLabel.text = conversation.name
        if let date = conversation.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
        if let message = conversation.message {
            messageLabel.text = message
            if conversation.hasUnreadMessage {
                messageLabel.font = Fonts.conversationCellUnreadMessage
            }
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = Fonts.conversationCellNoMessage
        }
    }
    
    // MARK: - Private methods

    private func setupUI() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews([avatarImageView, secondStackView])
        secondStackView.addArrangedSubviews([thirdStackView, messageLabel])
        thirdStackView.addArrangedSubviews([fullNameLabel, dateStackView])
        dateStackView.addArrangedSubviews([dateLabel, arrowImageView])
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }
    
    private func configureUI() {
        avatarImageView.setCornerRadius(24)
    }
}
