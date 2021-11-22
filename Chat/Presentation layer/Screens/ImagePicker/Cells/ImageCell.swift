//
//  ImageCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

final class ImageCell: UICollectionViewCell, ConfigurableCollectionCell {
    
    typealias ConfigurationModel = Data
    
    // MARK: - Private properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configure(with model: ConfigurationModel) {
        imageView.image = UIImage(data: model)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
