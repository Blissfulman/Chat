//
//  ChannelViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import Firebase

final class ChannelViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
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
        tableView.register(MessageCell.self, forCellReuseIdentifier: String(describing: MessageCell.self))
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
