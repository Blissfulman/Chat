//
//  ProfileViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func didChangeProfileData(profile: Profile)
}

final class ProfileViewController: KeyboardNotificationsViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let defaultLowerButtonsBottomSpacing: CGFloat = 30
    }
    
    private enum State {
        case editing
        case edited
        case saved
    }
    
    private enum SavingVariant {
        case gcd
        case operations
    }
    
    // MARK: - Private properties
    
    private lazy var topView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = Palette.lightBarColor
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.title
        label.text = "My Profile"
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var centralStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 32
        return stackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = ProfileNameTextField()
        textField.placeholder = "Name"
        textField.isEnabled = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldsEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = ProfileDescriptionTextField()
        textField.placeholder = "Profile information"
        textField.isEnabled = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldsEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Edit profile")
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Cancel")
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Save")
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private let progressView = ProgressView()
    private let imagePickerController = UIImagePickerController()
    private let didChangeProfileHandler: ((Profile) -> Void)
    private var buttonsStackViewBottomConstraint: NSLayoutConstraint?
    private var asyncDataManager: AsyncDataManagerProtocol = AsyncDataManager(asyncHandlerType: .gcd)
    // Хранение задачи сохранения данных необходимо для возможности её повторения
    private var savingTask: ((Profile, SavingVariant) -> Void)?
    private var isChangedAvatar = false
    /// Сохранённое состояние данных вью для возможности возврата к этому состоянию в случае нажатия кнопки "Cancel".
    private var savedViewData: (fullName: String?, description: String?, avatarImage: UIImage?)
    private var state: State = .saved {
        didSet {
            switch state {
            case .editing:
                if oldValue == .saved {
                    switchToEditingState()
                } else {
                    updateSaveButtonState()
                }
            case .edited:
                updateSaveButtonState()
            case .saved:
                switchToSavedState()
            }
        }
    }
    
    // MARK: - Initialization
    
    init(didChangeProfileHandler: @escaping ((Profile) -> Void)) {
        self.didChangeProfileHandler = didChangeProfileHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.round()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - KeyboardNotificationsViewController
    
    override func keyboardWillShow(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { keyboardFrame in
            self.buttonsStackViewBottomConstraint?.constant = -keyboardFrame.height
                - Constants.defaultLowerButtonsBottomSpacing
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            self.buttonsStackViewBottomConstraint?.constant = -Constants.defaultLowerButtonsBottomSpacing
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func editAvatarButtonTapped() {
        view.endEditing(true)
        
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        imageSelectionAlertController.addAction(galleryAction)
        imageSelectionAlertController.addAction(cameraAction)
        imageSelectionAlertController.addAction(cancelAction)
        present(imageSelectionAlertController, animated: true)
    }
    
    @objc
    private func editProfileButtonTapped() {
        saveCurrentViewData()
        isChangedAvatar = false
        state = .editing
    }
        
    @objc
    private func cancelButtonTapped() {
        view.endEditing(true)
        rollbackCurrentViewData()
        state = .saved
    }
    
    @objc
    private func saveButtonTapped() {
        view.endEditing(true)
        
        let savingAlertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let saveWithGCDAction = UIAlertAction(title: "Save with GCD", style: .default) { [weak self] _ in
            self?.saveData(savingVariant: .gcd)
        }
        let saveWithOperationsAction = UIAlertAction(title: "Save with Operations", style: .default) { [weak self] _ in
            self?.saveData(savingVariant: .operations)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        savingAlertController.addAction(saveWithGCDAction)
        savingAlertController.addAction(saveWithOperationsAction)
        savingAlertController.addAction(cancelAction)
        present(savingAlertController, animated: true)
    }
    
    @objc
    private func textFieldsEditingChanged() {
        guard !isChangedAvatar else { return }
        if fullNameTextField.text == savedViewData.fullName && descriptionTextField.text == savedViewData.description {
            state = .editing
        } else {
            state = .edited
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.roundCorners([.topLeft, .topRight], radius: 18)
        
        view.addSubview(avatarImageView)
        view.addSubview(centralStackView)
        view.addSubview(editAvatarButton)
        view.addSubview(buttonsStackView)
        view.addSubview(editProfileButton)
        topView.addSubview(topStackView)
        // Добавляется последним, чтобы быть более верхним слоем поверх остального контента
        view.addSubview(topView)
        
        topStackView.addArrangedSubviews(titleLabel, closeButton)
        centralStackView.addArrangedSubviews(fullNameTextField, descriptionTextField)
        buttonsStackView.addArrangedSubviews(cancelButton, saveButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70),
            
            topStackView.topAnchor.constraint(equalTo: topView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            topStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(lessThanOrEqualTo: topView.bottomAnchor, constant: 10),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            centralStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32),
            centralStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralStackView.bottomAnchor.constraint(lessThanOrEqualTo: buttonsStackView.topAnchor, constant: -24),
            
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            editProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            editProfileButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.defaultLowerButtonsBottomSpacing
            ),
            editProfileButton.heightAnchor.constraint(equalToConstant: 40),
            
            fullNameTextField.heightAnchor.constraint(equalToConstant: 38),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        buttonsStackViewBottomConstraint = buttonsStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Constants.defaultLowerButtonsBottomSpacing
        )
        buttonsStackViewBottomConstraint?.isActive = true
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        imagePickerController.delegate = self
        fetchInitialViewData()
    }
    
    private func fetchInitialViewData() {
        asyncDataManager.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.fullNameTextField.text = profile?.fullName
                self?.descriptionTextField.text = profile?.description
                if let avatarData = profile?.avatarData {
                    self?.avatarImageView.image = UIImage(data: avatarData)
                } else {
                    self?.avatarImageView.image = Images.noPhoto
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showProgressView() {
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        progressView.show()
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = isChangedAvatar || state == .edited
    }
    
    private func switchToEditingState() {
        editProfileButton.disappear(duration: 0.3) {
            self.buttonsStackView.appear(duration: 0.3)
        }
        editAvatarButton.appear(duration: 0.3)
        saveButton.isEnabled = false
        fullNameTextField.isEnabled = true
        descriptionTextField.isEnabled = true
    }
    
    private func switchToSavedState() {
        buttonsStackView.disappear(duration: 0.3) {
            self.editProfileButton.appear(duration: 0.3)
        }
        editAvatarButton.disappear(duration: 0.3)
        fullNameTextField.isEnabled = false
        descriptionTextField.isEnabled = false
    }
    
    /// Сохраняет текущее состояние вью для возможности возврата к этому состоянию в случае нажатия кнопки "Cancel" в процессе редактирования.
    private func saveCurrentViewData() {
        savedViewData.fullName = fullNameTextField.text
        savedViewData.description = descriptionTextField.text
        savedViewData.avatarImage = avatarImageView.image
    }
    
    /// Возвращает вью к состоянию, которое было до начала редактирования (при нажатии кнопки "Cancel").
    private func rollbackCurrentViewData() {
        fullNameTextField.text = savedViewData.fullName
        descriptionTextField.text = savedViewData.description
        avatarImageView.image = savedViewData.avatarImage
    }
    
    /// Сохранение текущих данных профиля в постоянное хранилище.
    private func saveData(savingVariant: SavingVariant) {
        let profile = Profile(
            fullName: fullNameTextField.text ?? "",
            description: descriptionTextField.text ?? "",
            avatarData: avatarImageView.image?.jpegData(compressionQuality: 0.5)
        )
        
        savingTask = { [weak self, asyncDataManager, didChangeProfileHandler] profile, savingVariant in
            guard let self = self else {
                // Если экран уже закрыт, то просто вызывается ещё одна попытка сохранить профиль
                asyncDataManager.saveProfile(profile: profile) { result in
                    if case .success = result { didChangeProfileHandler(profile) }
                }
                return
            }
            self.showProgressView()
            
            asyncDataManager.saveProfile(profile: profile) { result in
                self.progressView.hide()
                switch result {
                case .success:
                    self.state = .saved
                    self.showAlert(title: "Data saved")
                    didChangeProfileHandler(profile)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showFailureSavingAlert {
                        self.savingTask?(profile, savingVariant)
                    }
                }
            }
        }
        if savingVariant == .gcd {
            asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
        } else {
            asyncDataManager = AsyncDataManager(asyncHandlerType: .operations)
        }
        savingTask?(profile, savingVariant)
    }
    
    private func showFailureSavingAlert(repeatitionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
        let repeatitionAction = UIAlertAction(title: "Repeat", style: .default) { _ in
            repeatitionHandler?()
        }
        alert.addAction(okAction)
        alert.addAction(repeatitionAction)
        alert.preferredAction = repeatitionAction
        present(alert, animated: true)
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
        isChangedAvatar = true
        state = .edited
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
