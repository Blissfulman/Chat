//
//  ChannelListViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import Firebase

final class ChannelListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var openSettingsBarButton = UIBarButtonItem(
        image: Icons.settings,
        style: .plain,
        target: self,
        action: #selector(openSettingsBarButtonTapped)
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.rowHeight = 88
        tableView.estimatedRowHeight = 88
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var channels = [Channel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureUI()
        setupDataFetching()
    }
    
    // MARK: - Actions
    
    @objc
    private func openSettingsBarButtonTapped() {
        let themesViewController = ThemesViewController { [weak self] theme in
            self?.handleChangingTheme(to: theme)
        }
        themesViewController.modalPresentationStyle = .fullScreen
        present(themesViewController, animated: true)
    }
    
    @objc
    private func openProfileBarButtonTapped() {
        let profileVC = ProfileViewController()
        present(profileVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        tableView.register(ChannelCell.self, forCellReuseIdentifier: String(describing: ChannelCell.self))
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = openSettingsBarButton
        customProfileBarButton { [weak self] barButtonItem in
            self?.navigationItem.rightBarButtonItem = barButtonItem
        }
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
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        title = "Channels"
    }
    
    private func setupDataFetching() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                self?.showAlert(title: "Error", message: error?.localizedDescription)
                return
            }
            if let channels = snapshot?.documents {
                self?.channels = channels.compactMap { Channel(snapshot: $0) }
            }
        }
    }
    
    private func handleChangingTheme(to theme: Theme) {
        let asyncHandler = GCDAsyncHandler(qos: .userInteractive)
        asyncHandler.handle {
            NavigationController.updateColors(for: theme)
            SettingsManager().theme = theme
        }
    }
    
    private func customProfileBarButton(completion: @escaping (UIBarButtonItem) -> Void) {
        let size = CGSize(width: 40, height: 40)
        
        asyncDataManager.fetchProfile { [weak self] result in
            guard let self = self else { return }
            var iconData = Data()
            
            if case let .success(profile) = result,
               let avatarImageData = profile?.avatarData {
                iconData = avatarImageData
            } else {
                iconData = Images.noPhoto.jpegData(compressionQuality: 0.5) ?? Data()
            }
            iconData = iconData.resizeImageFromImageData(to: CGSize(width: size.width, height: size.height))

            let button = UIButton()
            button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            button.addTarget(self, action: #selector(self.openProfileBarButtonTapped), for: .touchUpInside)
            button.setImage(UIImage(data: iconData), for: .normal)
            button.setCornerRadius(size.width / 2)
            
            completion(UIBarButtonItem(customView: button))
        }
    }
}

// MARK: - UITableViewDataSource

extension ChannelListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChannelCell.self),
            for: indexPath
        ) as? ChannelCell else { return UITableViewCell() }
        
        cell.configure(with: channels[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelName = channels[indexPath.row].name
        let channelVC = ChannelViewController(channelName: channelName)
        navigationController?.show(channelVC, sender: self)
    }
}
