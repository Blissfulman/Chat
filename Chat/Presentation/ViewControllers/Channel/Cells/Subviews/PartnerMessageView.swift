//
//  PartnerMessageView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.10.2021.
//

final class PartnerMessageView: UIView {
    
    // MARK: - Nested types
    
    struct Model {
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
        addSubview(messageLabel)
        addSubview(dateLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            shapeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            shapeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            shapeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            shapeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            messageLabel.topAnchor.constraint(equalTo: shapeImageView.topAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: shapeImageView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -26),
            
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: shapeImageView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: shapeImageView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureUI(model: Model) {
        messageLabel.text = model.text
        dateLabel.text = model.date
        shapeImageView.setMessageShapeShadow()
    }
}
