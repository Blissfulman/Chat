//
//  ChannelViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import Firebase

final class ChannelViewController: UIViewController {
    
    // MARK: - Nested types
    
    enum Constants {
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
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
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
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setImage(Icons.addToMessage, for: .normal)
        return button
    }()
    
    private let channel: Channel
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        let channelIdentifier = channel.identifier
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    private var messages = [Message]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    init(channel: Channel) {
        self.channel = channel
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
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
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
            
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1),
            
            bottomViewStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 17),
            bottomViewStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            bottomViewStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            
            newMessageTextField.heightAnchor.constraint(equalToConstant: Constants.newMessageTexrFieldHeight),
            addButton.widthAnchor.constraint(equalToConstant: 19)
        ])
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
                self?.messages = messages.map { Message(snapshot: $0) }
            }
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
        
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
