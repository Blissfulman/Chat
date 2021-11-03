//
//  MessageCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

final class MessageCell: UITableViewCell, ConfigurableCell {
    
    typealias ConfigurationModel = CellModel
    
    // MARK: - Nested types
    
    struct CellModel {
        let message: Message
        let mySenderID: String?
    }
    
    // MARK: - Private properties
    
    private let settingsManager = SettingsManager()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        let message = model.message
        if message.senderID == model.mySenderID {
            let model = MyMessageView.Model(text: message.content, date: message.created.messageCellDate())
            let messageView = MyMessageView(frame: .zero, model: model)
            contentView.addSubview(messageView)
            setupMyMessageLayout(messageView)
        } else {
            let model = PartnerMessageView.Model(
                authorName: message.senderName,
                text: message.content,
                date: message.created.messageCellDate()
            )
            let messageView = PartnerMessageView(frame: .zero, model: model)
            contentView.addSubview(messageView)
            setupPartnerMessageLayout(messageView)
        }
    }
    
    // MARK: - Private methods
    
    private func setupPartnerMessageLayout(_ messageView: UIView) {
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            messageView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -(contentView.bounds.width / 4)
            ),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupMyMessageLayout(_ messageView: UIView) {
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: (bounds.width / 4)
            ),
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
}
