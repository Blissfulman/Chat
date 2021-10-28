//
//  ChannelViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import Firebase

final class ChannelViewController: KeyboardNotificationsViewController {
    
    // MARK: - Nested types
    
    enum Constants {
        static let bottomViewHeight: CGFloat = 80
        static let newMessageTexrFieldHeight: CGFloat = 32
    }
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView().prepareForAutoLayout()
        let theme = SettingsManager().theme
        view.backgroundColor = theme.themeColors.backgroundColor
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = .gray // TEMP
        return view
    }()
    
    private lazy var bottomViewStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.alignment = .center
        stackView.spacing = 13.5
        return stackView
    }()
    
    private lazy var newMessageTextField: UITextField = {
        let textField = NewMessageTextField()
        textField.setCornerRadius(Constants.newMessageTexrFieldHeight / 2)
        textField.delegate = self
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setImage(Icons.addToMessage, for: .normal)
        return button
    }()
    
    private var bottomViewBottomConstraint: NSLayoutConstraint?
    private let defaultBottomViewBottomSpacing: CGFloat = 0
    private let settingsManager = SettingsManager()
    private let channel: Channel
    private let senderName: String
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        let channelIdentifier = channel.identifier
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    private var messages = [Message]() {
        didSet {
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    // MARK: - Initialization
    
    init(channel: Channel, senderName: String) {
        self.channel = channel
        self.senderName = senderName
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
        setupDataFetching()
    }
    
    // MARK: - KeyboardNotificationsViewController
    
    override func keyboardWillShow(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { keyboardFrame in
            self.bottomViewBottomConstraint?.constant = -keyboardFrame.height - self.defaultBottomViewBottomSpacing
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            self.bottomViewBottomConstraint?.constant = -self.defaultBottomViewBottomSpacing
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(borderView)
        bottomView.addSubview(bottomViewStackView)
        bottomViewStackView.addArrangedSubviews(addButton, newMessageTextField)
        tableView.register(MessageCell.self, forCellReuseIdentifier: String(describing: MessageCell.self))
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -Constants.bottomViewHeight),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            borderView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomViewStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 17),
            bottomViewStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            bottomViewStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            
            newMessageTextField.heightAnchor.constraint(equalToConstant: Constants.newMessageTexrFieldHeight),
            addButton.widthAnchor.constraint(equalToConstant: 19)
        ])
        
        bottomViewBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomViewBottomConstraint?.isActive = true
    }
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        title = channel.name
    }
    
    private func setupDataFetching() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                self?.showAlert(title: "Error", message: error?.localizedDescription)
                return
            }
            if let messages = snapshot?.documents {
                self?.messages = messages.compactMap { Message(snapshot: $0) }.sorted { $0.created < $1.created }
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        let newMessage = Message(
            content: text,
            created: Date(),
            senderID: settingsManager.mySenderID,
            senderName: senderName
        )
        reference.addDocument(data: newMessage.toDictionary)
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        tableView.scrollToBottom(animated: false)
        // TEMP: Костыль, т.к. с первого раза не всегда до самого низа скроллится, а как это решить ещё не понял
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.tableView.scrollToBottom(animated: false)
        }
    }
}

// MARK: - UITableViewDataSource

extension ChannelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MessageCell.self),
            for: indexPath
        ) as? MessageCell else { return UITableViewCell() }
        
        let cellModel = MessageCell.ConfigurationModel(
            message: messages[indexPath.row],
            mySenderID: settingsManager.mySenderID
        )
        cell.configure(with: cellModel)
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension ChannelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            sendMessage(text)
            textField.text = ""
        }
        return true
    }
}
