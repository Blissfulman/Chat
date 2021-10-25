//
//  ChannelListViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import Firebase

final class ChannelListViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Sections: Int, CaseIterable {
        case online
        case history
        
        var title: String {
            switch self {
            case .online:
                return "Online"
            case .history:
                return "History"
            }
        }
    }
    
    // MARK: - Private properties
    
    private lazy var openSettingsBarButton = UIBarButtonItem(
        image: Icons.settings,
        style: .plain,
        target: self,
        action: #selector(openSettingsBarButtonTapped)
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let onlineChannels: [Channel] = Channel.mockData().filter { $0.isOnline }
    private let offlineChannels: [Channel] = Channel.mockData().filter { !$0.isOnline }
    private let asyncDataManager = AsyncDataManager(asyncHandlerType: .gcd)
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureUI()
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
        title = "Chat"
        tableView.rowHeight = 88
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == Sections.online.rawValue ? onlineChannels.count : offlineChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ChannelCell.self),
            for: indexPath
        ) as? ChannelCell else { return UITableViewCell() }
        
        cell.configure(
            with: indexPath.section == Sections.online.rawValue
                ? onlineChannels[indexPath.row]
                : offlineChannels[indexPath.row]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Sections(rawValue: section)?.title
    }
}

// MARK: - UITableViewDelegate

extension ChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactName = indexPath.section == Sections.online.rawValue
            ? onlineChannels[indexPath.row].name
            : offlineChannels[indexPath.row].name
        let channelVC = ChannelViewController(contactName: contactName)
        navigationController?.show(channelVC, sender: self)
    }
}
