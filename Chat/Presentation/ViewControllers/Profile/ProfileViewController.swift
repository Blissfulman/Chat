//
//  ProfileViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

final class ProfileViewController: KeyboardNotificationsViewController {
    
    // MARK: - Nested types
    
    enum State {
        case editing
        case edited
        case saved
    }
    
    // MARK: - Private properties
    
    private var topView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = Palette.lightBarColor
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
        stackView.spacing = 32
        return stackView
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = ProfileNameTextField()
        textField.placeholder = "Name"
        textField.isEnabled = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(fullNameTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextView: ProfileTextView = {
        let textView = ProfileTextView(withPlaceholder: "Profile information")
        textView.didChangedHandler = { [weak self] in
            self?.state = textView.nonplaceholderText == self?.savedData.description ? .editing : .edited
        }
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    private var editAvatarButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var editProfileButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Edit profile")
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isHidden = true
        return stackView
    }()
    
    private var cancelButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Cancel")
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = ProfileFilledButton(withTitle: "Save")
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imagePickerController = UIImagePickerController()
    private var buttonsStackViewBottomConstraint: NSLayoutConstraint?
    private let defaultLowerButtonsBottomSpacing: CGFloat = 30
    private var savedData: (fullName: String?, description: String?, avatarImage: UIImage?)
    private var state: State = .saved {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Initialization
    
    init() {
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
        saveCurrentViewData()
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
                - self.defaultLowerButtonsBottomSpacing
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            self.buttonsStackViewBottomConstraint?.constant = -self.defaultLowerButtonsBottomSpacing
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
        let savingAlertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let saveWithGCDAction = UIAlertAction(title: "Save with GCD", style: .default) { [weak self] _ in
            guard let self = self else { return }
            print("Saved with GCD")
            self.saveCurrentViewData()
            self.state = .saved
        }
        let saveWithOperationsAction = UIAlertAction(title: "Save with Operations", style: .default) { [weak self] _ in
            guard let self = self else { return }
            print("Saved with Operations")
            self.saveCurrentViewData()
            self.state = .saved
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        savingAlertController.addAction(saveWithGCDAction)
        savingAlertController.addAction(saveWithOperationsAction)
        savingAlertController.addAction(cancelAction)
        present(savingAlertController, animated: true)
    }
    
    @objc
    private func fullNameTextFieldEditingChanged() {
        state = (fullNameTextField.text == savedData.fullName) ? .editing : .edited
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
        centralStackView.addArrangedSubviews(fullNameTextField, descriptionTextView)
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
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            editProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            editProfileButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant:  -defaultLowerButtonsBottomSpacing
            ),
            editProfileButton.heightAnchor.constraint(equalToConstant: 40),
            
            fullNameTextField.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        buttonsStackViewBottomConstraint = buttonsStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -defaultLowerButtonsBottomSpacing
        )
        buttonsStackViewBottomConstraint?.isActive = true
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        imagePickerController.delegate = self
    }
    
    private func updateView() {
        switch state {
        case .editing:
            handleGoToEditingState()
        case .edited:
            handleGoToEditedState()
        case .saved:
            handleGoToSavedState()
        }
    }
    
    private func handleGoToEditingState() {
        editProfileButton.disappear(duration: 0.3) {
            self.buttonsStackView.appear(duration: 0.3)
        }
        editAvatarButton.appear(duration: 0.3)
        saveButton.isEnabled = false
        fullNameTextField.isEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
    }
    
    private func handleGoToEditedState() {
        saveButton.isEnabled = true
    }
    
    private func handleGoToSavedState() {
        buttonsStackView.disappear(duration: 0.3) {
            self.editProfileButton.appear(duration: 0.3)
        }
        editAvatarButton.disappear(duration: 0.3)
        fullNameTextField.isEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
    }
    
    private func saveCurrentViewData() {
        savedData.fullName = fullNameTextField.text
        savedData.description = descriptionTextView.nonplaceholderText
        savedData.avatarImage = avatarImageView.image
    }
    
    private func rollbackCurrentViewData() {
        fullNameTextField.text = savedData.fullName
        descriptionTextView.text = savedData.description
        avatarImageView.image = savedData.avatarImage
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        defer {
            imagePickerController.dismiss(animated: true)
            state = .edited
        }
        guard let image = info[.originalImage] as? UIImage else { return }
        avatarImageView.image = image
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
