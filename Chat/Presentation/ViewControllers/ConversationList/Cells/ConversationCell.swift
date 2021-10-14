//
//  ConversationCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

final class ConversationCell: UITableViewCell, ConfigurableCell {
    
    typealias ConfigurationModel = Conversation
    
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
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.conversationCellDate
        label.textColor = Palette.labelGray
        return label
    }()
    
    private var arrowImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Icons.arrowRight
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.conversationCellReadMessage
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
        contentView.backgroundColor = .white
        avatarImageView.image = Images.noPhoto
        fullNameLabel.text = nil
        dateLabel.text = nil
        messageLabel.text = nil
        messageLabel.font = Fonts.conversationCellReadMessage
    }
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        if let avatarData = model.avatarData {
            avatarImageView.image = UIImage(data: avatarData)
        }
        fullNameLabel.text = model.name
        if let date = model.date {
            dateLabel.text = date.conversationCellDate()
        }
        if let message = model.message {
            messageLabel.text = message
            if model.hasUnreadMessage {
                messageLabel.font = Fonts.conversationCellUnreadMessage
            }
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = Fonts.conversationCellNoMessage
        }
        if model.isOnline {
            contentView.backgroundColor = .yellow.withAlphaComponent(0.1)
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
    }
}
