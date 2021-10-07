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
    
    private var partnerShapeImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        imageView.image = Images.partnerMessageShape
        return imageView
    }()
    
    private var myShapeImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        imageView.image = Images.myMessageShape
        return imageView
    }()
    
    private var partnerMessageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellText
        label.numberOfLines = 0
        return label
    }()
    
    private var myMessageLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellText
        label.numberOfLines = 0
        return label
    }()
    
    private var partnerDateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.messageCellDate
        label.textColor = .black.withAlphaComponent(0.25)
        return label
    }()
    
    private var myDateLabel: UILabel = {
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
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        partnerShapeImageView.isHidden = true
        myShapeImageView.isHidden = true
    }
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        let dateFormatter = DateFormatter() // TEMP - нужно будет вынести форматтер из вью
        dateFormatter.timeStyle = .short
        
        if model.isMine {
            myMessageLabel.text = model.text
            myDateLabel.text = dateFormatter.string(from: model.date)
            myShapeImageView.isHidden = false
        } else {
            partnerMessageLabel.text = model.text
            partnerDateLabel.text = dateFormatter.string(from: model.date)
            partnerShapeImageView.isHidden = false
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        contentView.addSubview(partnerShapeImageView)
        partnerShapeImageView.addSubview(partnerMessageLabel)
        partnerShapeImageView.addSubview(partnerDateLabel)
        contentView.addSubview(myShapeImageView)
        myShapeImageView.addSubview(myMessageLabel)
        myShapeImageView.addSubview(myDateLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Partner's message views
            partnerShapeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            partnerShapeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            partnerShapeImageView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -(contentView.bounds.width / 4)
            ),
            partnerShapeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            partnerMessageLabel.topAnchor.constraint(equalTo: partnerShapeImageView.topAnchor, constant: 5),
            partnerMessageLabel.leadingAnchor.constraint(equalTo: partnerShapeImageView.leadingAnchor, constant: 16),
            partnerMessageLabel.trailingAnchor.constraint(equalTo: partnerShapeImageView.trailingAnchor, constant: -8),
            partnerMessageLabel.bottomAnchor.constraint(equalTo: partnerShapeImageView.bottomAnchor, constant: -26),
            
            partnerDateLabel.trailingAnchor.constraint(equalTo: partnerShapeImageView.trailingAnchor, constant: -8),
            partnerDateLabel.bottomAnchor.constraint(equalTo: partnerShapeImageView.bottomAnchor, constant: -6),
            
            // My message views
            myShapeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            myShapeImageView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: (contentView.bounds.width / 4)
            ),
            myShapeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            myShapeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            myMessageLabel.topAnchor.constraint(equalTo: myShapeImageView.topAnchor, constant: 5),
            myMessageLabel.leadingAnchor.constraint(equalTo: myShapeImageView.leadingAnchor, constant: 8),
            myMessageLabel.trailingAnchor.constraint(equalTo: myShapeImageView.trailingAnchor, constant: -16),
            myMessageLabel.bottomAnchor.constraint(equalTo: myShapeImageView.bottomAnchor, constant: -26),
            
            myDateLabel.trailingAnchor.constraint(equalTo: myShapeImageView.trailingAnchor, constant: -16),
            myDateLabel.bottomAnchor.constraint(equalTo: myShapeImageView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureUI() {
        selectionStyle = .none
        partnerShapeImageView.layer.shadowRadius = 1
        partnerShapeImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        partnerShapeImageView.layer.shadowOpacity = 0.1
        myShapeImageView.layer.shadowRadius = 1
        myShapeImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myShapeImageView.layer.shadowOpacity = 0.1
    }
}
