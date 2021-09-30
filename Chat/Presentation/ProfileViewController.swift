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
        label.font = Fonts.title
        label.text = "My Profile"
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Close", for: .normal)
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
        label.font = Fonts.subTitle
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.body
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var editAvatarButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = Palette.barGray
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Save", for: .normal)
        button.setCornerRadius(14)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imagePickerController = UIImagePickerController()
    
    // MARK: - Initialization
    
    init() {
        print("Edit button frame in \(#function): ", editAvatarButton.frame)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Edit button frame in \(#function): ", editAvatarButton.frame)
        setupUI()
        setupLayout()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.round()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Здесь фрейм уже будет иметь правильные значения после расчёта на основе констрейнтов
        print("Edit button frame in \(#function): ", editAvatarButton.frame)
    }
    
    // MARK: - Actions
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func editAvatarButtonTapped() {
        print("Select profile image")
        let imageSelectionAlertController = UIAlertController(
            title: "Select image source",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let galleryAction = UIAlertAction(title: "Select from the gallery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.present(self.imagePickerController, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard UIImagePickerController.isCameraDeviceAvailable(.rear) else {
                self.showAlert(title: "The camera insn't available")
                return
            }
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        imageSelectionAlertController.addAction(galleryAction)
        imageSelectionAlertController.addAction(cameraAction)
        present(imageSelectionAlertController, animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        print("Save tapped")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
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
            centralStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralStackView.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        imagePickerController.delegate = self
        fullNameLabel.text = "Marina Dudarenko"
        descriptionLabel.text = "UX/UI designer, web-designer Moscow, Russia"
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        defer { imagePickerController.dismiss(animated: true) }
        guard let image = info[.originalImage] as? UIImage else { return }
        avatarImageView.image = image
    }
}
