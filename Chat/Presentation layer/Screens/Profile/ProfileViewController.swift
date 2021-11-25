//
//  ProfileViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayTheme(viewModel: ChannelModel.SetupTheme.ViewModel)
    func displayProfile(viewModel: ProfileModel.FetchProfile.ViewModel)
    func displayEditingAvatarAlert(viewModel: ProfileModel.EditingAvatarAlert.ViewModel)
    func displayEditingState(viewModel: ProfileModel.EditingState.ViewModel)
    func displaySavedState(viewModel: ProfileModel.SavedState.ViewModel)
    func updateSaveButtonState(viewModel: ProfileModel.UpdateSaveButtonState.ViewModel)
    func displaySavingProfileAlert(viewModel: ProfileModel.SavingProfileAlert.ViewModel)
    func showProgressView(viewModel: ProfileModel.ShowProgressView.ViewModel)
    func hideProgressView(viewModel: ProfileModel.HideProgressView.ViewModel)
    func displayProfileSavedAlert(viewModel: ProfileModel.ProfileSavedAlert.ViewModel)
    func displaySavingProfileError(viewModel: ProfileModel.SavingProfileError.ViewModel)
}

final class ProfileViewController: KeyboardNotificationsViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let defaultLowerButtonsBottomSpacing: CGFloat = 30
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
        imageView.contentMode = .scaleAspectFill
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
    private var buttonsStackViewBottomConstraint: NSLayoutConstraint?
    private let interactor: ProfileBusinessLogic
    private let router: ProfileRoutingLogic
    
    // MARK: - Initialization
    
    init(interactor: ProfileBusinessLogic, router: ProfileRoutingLogic) {
        self.interactor = interactor
        self.router = router
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
        router.dismiss()
    }
    
    @objc
    private func editAvatarButtonTapped() {
        view.endEditing(true)
        interactor.requestEditingAvatarAlert(request: ProfileModel.EditingAvatarAlert.Request())
    }
    
    @objc
    private func editProfileButtonTapped() {
        let request = ProfileModel.EditProfileButtonTapped.Request(
            fullName: fullNameTextField.text,
            description: descriptionTextField.text,
            avatarImageData: avatarImageView.image?.pngData()
        )
        interactor.editProfileButtonTapped(request: request)
    }
        
    @objc
    private func cancelButtonTapped() {
        view.endEditing(true)
        // Возврат вью к состоянию, которое было до начала редактирования
        interactor.rollbackCurrentViewData(request: ProfileModel.RollbackCurrentViewData.Request())
    }
    
    @objc
    private func saveButtonTapped() {
        view.endEditing(true)
        interactor.requestSavingProfileAlert(request: ProfileModel.SavingProfileAlert.Request())
    }
    
    @objc
    private func textFieldsEditingChanged() {
        let request = ProfileModel.TextFieldsEditingChanged.Request(
            fullName: fullNameTextField.text,
            description: descriptionTextField.text
        )
        interactor.textFieldsEditingChanged(request: request)
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
        interactor.setupTheme(request: ChannelModel.SetupTheme.Request())
        interactor.fetchProfile(request: ProfileModel.FetchProfile.Request())
    }
    
    /// Сохранение текущих данных профиля в постоянное хранилище.
    private func saveData(asyncHandlerType: AsyncHandlerType) {
        let request = ProfileModel.SaveProfile.Request(
            fullName: fullNameTextField.text,
            description: descriptionTextField.text,
            avatarImageData: avatarImageView.image?.jpegData(compressionQuality: 0.5),
            asyncHandlerType: asyncHandlerType
        )
        interactor.saveProfile(request: request)
    }
}

// MARK: - ProfileDisplayLogic

extension ProfileViewController: ProfileDisplayLogic {
    
    func displayTheme(viewModel: ChannelModel.SetupTheme.ViewModel) {
        topView.backgroundColor = viewModel.theme.backgroundColor
        titleLabel.textColor = viewModel.theme.fontColor
    }
    
    func displayProfile(viewModel: ProfileModel.FetchProfile.ViewModel) {
        fullNameTextField.text = viewModel.fullName
        descriptionTextField.text = viewModel.description
        avatarImageView.image = UIImage(data: viewModel.avatarImageData)
    }
    
    func displayEditingAvatarAlert(viewModel: ProfileModel.EditingAvatarAlert.ViewModel) {
        let alertController = editAvatarAlert(title: viewModel.title, galleryAction: { [weak self] in
            guard let self = self else { return }
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.present(self.imagePickerController, animated: true)
        }, cameraAction: { [weak self] in
            guard let self = self else { return }
            guard UIImagePickerController.isCameraDeviceAvailable(.rear) else {
                self.showAlertController(title: "The camera insn't available")
                return
            }
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        })
        present(alertController, animated: true)
    }
    
    func displayEditingState(viewModel: ProfileModel.EditingState.ViewModel) {
        editProfileButton.disappear(duration: 0.3) {
            self.buttonsStackView.appear(duration: 0.3)
        }
        editAvatarButton.appear(duration: 0.3)
        saveButton.isEnabled = false
        fullNameTextField.isEnabled = true
        descriptionTextField.isEnabled = true
    }
    
    func displaySavedState(viewModel: ProfileModel.SavedState.ViewModel) {
        buttonsStackView.disappear(duration: 0.3) {
            self.editProfileButton.appear(duration: 0.3)
        }
        editAvatarButton.disappear(duration: 0.3)
        fullNameTextField.isEnabled = false
        descriptionTextField.isEnabled = false
    }
    
    func updateSaveButtonState(viewModel: ProfileModel.UpdateSaveButtonState.ViewModel) {
        saveButton.isEnabled = viewModel.isEnabledButton
    }
    
    func displaySavingProfileAlert(viewModel: ProfileModel.SavingProfileAlert.ViewModel) {
        let alertController = savingProfileAlertController(saveWithGCDAction: { [weak self] in
            self?.saveData(asyncHandlerType: .gcd)
        }, saveWithOperationsAction: { [weak self] in
            self?.saveData(asyncHandlerType: .operations)
        })
        present(alertController, animated: true)
    }
    
    func showProgressView(viewModel: ProfileModel.ShowProgressView.ViewModel) {
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        progressView.show()
    }
    
    func hideProgressView(viewModel: ProfileModel.HideProgressView.ViewModel) {
        progressView.hide()
    }
    
    func displayProfileSavedAlert(viewModel: ProfileModel.ProfileSavedAlert.ViewModel) {
        showAlertController(title: viewModel.title)
    }
    
    func displaySavingProfileError(viewModel: ProfileModel.SavingProfileError.ViewModel) {
        let alertController = savingErrorAlert(
            title: viewModel.title,
            message: viewModel.message,
            retryHandler: viewModel.retryHandler
        )
        present(alertController, animated: true)
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
        interactor.didSelectNewAvatar(request: ProfileModel.DidSelectNewAvatar.Request())
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
