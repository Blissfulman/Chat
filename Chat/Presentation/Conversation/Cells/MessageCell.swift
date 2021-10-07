//
//  MessageCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

import UIKit

final class MessageCell: UITableViewCell, ConfigurableCell {
    
    typealias ConfigurationModel = Message
    
    // MARK: - Private properties
    
    private var shapeImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleToFill
        imageView.image = Images.partnerMessageShape
        return imageView
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellText
        label.numberOfLines = 0
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellDate
        label.textColor = .black.withAlphaComponent(0.25)
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
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        messageLabel.text = model.text
        let dateFormatter = DateFormatter() // TEMP - нужно будет вынести форматтер из вью
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: model.date)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        contentView.addSubview(shapeImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            shapeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            shapeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            shapeImageView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -(contentView.bounds.width / 4)
            ),
            shapeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            messageLabel.topAnchor.constraint(equalTo: shapeImageView.topAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: shapeImageView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -26),
            
            dateLabel.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
}
