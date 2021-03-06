//
//  MessageCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

import UIKit

final class MessageCell: UITableViewCell, ConfigurableTableCell {
    
    typealias ConfigurationModel = Message
    
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
        if model.senderID == GlobalData.mySenderID {
            let viewModel = MyMessageViewModel(text: model.content, date: model.created.messageCellDate())
            let messageView = MyMessageView(viewModel: viewModel)
            contentView.addSubview(messageView)
            setupMyMessageLayout(messageView)
        } else {
            let viewModel = PartnerMessageViewModel(
                authorName: model.senderName,
                text: model.content,
                date: model.created.messageCellDate()
            )
            let messageView = PartnerMessageView(viewModel: viewModel)
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
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
