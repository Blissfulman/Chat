//
//  ProfileViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 26.09.2021.
//

final class ProfileViewController: KeyboardNotificationsViewController {
    
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
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Images.noPhoto
        return imageView
    }()
    
    private var fullTextField: UITextField = {
        let textField = UITextField().prepareForAutoLayout()
        textField.font = Fonts.subTitle
        return textField
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView().prepareForAutoLayout()
        textView.font = Fonts.body
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        return textView
    }()
    
    private var editAvatarButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = Palette.lightBarColor
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.setCornerRadius(14)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = Palette.lightBarColor
        button.titleLabel?.font = Fonts.buttonTitle
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Save", for: .normal)
        button.setCornerRadius(14)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imagePickerController = UIImagePickerController()
    private var buttonsStackViewBottomConstraint: NSLayoutConstraint?
    private let defaultLowerButtonsBottomSpacing: CGFloat = 30
    
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
    private func cancelButtonTapped() {
        print("Cancel tapped")
    }
    
    @objc
    private func saveButtonTapped() {
        print("Save tapped")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.roundCorners([.topLeft, .topRight], radius: 18)
        
        view.addSubview(centralStackView)
        view.addSubview(editAvatarButton)
        view.addSubview(buttonsStackView)
        topView.addSubview(topStackView)
        // Добавляется последним, чтобы быть более верхним слоем поверх остального контента
        view.addSubview(topView)
        
        topStackView.addArrangedSubviews(titleLabel, closeButton)
        centralStackView.addArrangedSubviews(avatarImageView, fullTextField, descriptionTextView)
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
            
            centralStackView.topAnchor.constraint(lessThanOrEqualTo: topView.bottomAnchor, constant: 10),
            centralStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            centralStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            centralStackView.bottomAnchor.constraint(lessThanOrEqualTo: buttonsStackView.topAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        buttonsStackViewBottomConstraint = buttonsStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -30
        )
        buttonsStackViewBottomConstraint?.isActive = true
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        imagePickerController.delegate = self
        fullTextField.text = "Marina Dudarenko" // TEMP
        descriptionTextView.text = "UX/UI designer, web-designer Moscow, Russia" // TEMP
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
