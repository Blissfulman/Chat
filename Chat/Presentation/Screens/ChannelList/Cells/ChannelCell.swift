//
//  ChannelCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import UIKit

final class ChannelCell: UITableViewCell, ConfigurableCell {
    
    typealias ConfigurationModel = Channel
    
    // MARK: - Private properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var secondStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var thirdStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.alignment = .center
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.channelCellName
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.channelCellDate
        label.textColor = Palette.labelGray
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Icons.arrowRight
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.channelCellReadMessage
        label.textColor = Palette.labelGray
        label.numberOfLines = 2
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
        super.prepareForReuse()
        fullNameLabel.text = nil
        dateLabel.text = nil
        messageLabel.text = nil
        messageLabel.font = Fonts.channelCellReadMessage
    }
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        fullNameLabel.text = model.name
        if let date = model.lastActivity {
            dateLabel.text = date.channelCellDate()
        }
        if let message = model.lastMessage {
            messageLabel.text = message
            if model.lastMessage != nil {
                messageLabel.font = Fonts.channelCellUnreadMessage
            }
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = Fonts.channelCellNoMessage
        }
    }
    
    // MARK: - Private methods

    private func setupUI() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(avatarImageView, secondStackView)
        secondStackView.addArrangedSubviews(thirdStackView, messageLabel)
        thirdStackView.addArrangedSubviews(fullNameLabel, dateStackView)
        dateStackView.addArrangedSubviews(dateLabel, arrowImageView)
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
        selectionStyle = .none
        avatarImageView.image = Images.noPhoto // TEMP
    }
}
