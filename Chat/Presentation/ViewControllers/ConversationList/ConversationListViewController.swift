//
//  ConversationListViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import UIKit

final class ConversationListViewController: UIViewController {
    
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
    
    private lazy var openProfileBarButton = UIBarButtonItem(
        image: Icons.avatarTemp, // TEMP
        style: .plain,
        target: self,
        action: #selector(openProfileBarButtonTapped)
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let onlineConversations: [Conversation] = Conversation.mockData().filter { $0.isOnline }
    private let offlineConversations: [Conversation] = Conversation.mockData().filter { !$0.isOnline }
    
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
        let themesViewController = ThemesViewController(delegate: self)
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
        navigationItem.leftBarButtonItem = openSettingsBarButton
        navigationItem.rightBarButtonItem = openProfileBarButton
        
        view.addSubview(tableView)
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: String(describing: ConversationCell.self))
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureUI() {
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        title = "Chat"
        tableView.rowHeight = 88
    }
}

// MARK: - UITableViewDataSource

extension ConversationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == Sections.online.rawValue ? onlineConversations.count : offlineConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ConversationCell.self),
            for: indexPath
        ) as? ConversationCell else { return UITableViewCell() }
        
        cell.configure(
            with: indexPath.section == Sections.online.rawValue
                ? onlineConversations[indexPath.row]
                : offlineConversations[indexPath.row]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Sections(rawValue: section)?.title
    }
}

// MARK: - UITableViewDelegate

extension ConversationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactName = indexPath.section == Sections.online.rawValue
            ? onlineConversations[indexPath.row].name
            : offlineConversations[indexPath.row].name
        let conversationVC = ConversationViewController(contactName: contactName)
        navigationController?.show(conversationVC, sender: self)
    }
}

// MARK: - ThemesViewControllerDelegate

extension ConversationListViewController: ThemesViewControllerDelegate {
    
    func didChooseTheme(_ theme: Theme) {
        print(theme)
    }
}
