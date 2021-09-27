//
//  ProfileViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var topView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = Palette.barGray
        return view
    }()
    
    private var topStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "My Profile"
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var centralStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private var fullNameLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "Marina Dudarenko"
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.text = "UX/UI designer, web-designer Moscow, Russia"
        return label
    }()
    
    private var editAvatarButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = Palette.barGray
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.setCornerRadius(14)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.round()
    }
    // MARK: - Actions
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func editAvatarButtonTapped() {
        print("Выбери изображение профиля")
        let actionSheetAC = UIAlertController(
            title: "Выберите источник",
            message: "Откуда взять изображение?",
            preferredStyle: .actionSheet
        )
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { action in
            print("Камера")
        }
        let galleryAction = UIAlertAction(title: "Галерея", style: .default) { action in
            print("Галерея")
        }
        actionSheetAC.addAction(cameraAction)
        actionSheetAC.addAction(galleryAction)
        present(actionSheetAC, animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        print("Save tapped")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.roundCorners([.topLeft, .topRight], radius: 18)
        
        view.addSubview(topView)
        view.addSubview(centralStackView)
        view.addSubview(editAvatarButton)
        view.addSubview(saveButton)
        topView.addSubview(topStackView)
        
        topStackView.addArrangedSubviews([titleLabel, closeButton])
        centralStackView.addArrangedSubviews([avatarImageView, fullNameLabel, descriptionLabel])
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 96),
            
            topStackView.topAnchor.constraint(equalTo: topView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            topStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            centralStackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            centralStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 240),
            avatarImageView.heightAnchor.constraint(equalToConstant: 240),
            
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
