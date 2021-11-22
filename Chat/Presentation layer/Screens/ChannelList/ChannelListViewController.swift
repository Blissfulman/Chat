//
//  ChannelListViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import Foundation
import UIKit

protocol ChannelListDisplayLogic: AnyObject {
    func displayProfileData(viewModel: ChannelListModel.UpdateProfile.ViewModel)
    func displayFetchingChannelsError(viewModel: ChannelListModel.FetchingChannelsError.ViewModel)
    func displayAddChannelAlert(viewModel: ChannelListModel.AddChannelAlert.ViewModel)
    func displaySelectedChannel(viewModel: ChannelListModel.OpenChannel.ViewModel)
}

final class ChannelListViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let profileBarButtonSize = CGSize(width: 40, height: 40)
    }
    
    // MARK: - Private properties
    
    private lazy var openSettingsBarButton = UIBarButtonItem(
        image: Icons.settings,
        style: .plain,
        target: self,
        action: #selector(openSettingsBarButtonTapped)
    )
    
    private lazy var addChannelBarButton = UIBarButtonItem(
        image: Icons.addToMessage, // TEMP
        style: .plain,
        target: self,
        action: #selector(addChannelBarButtonTapped)
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.rowHeight = 88
        tableView.estimatedRowHeight = 88
        tableView.delegate = self
        tableView.registerCell(type: ChannelCell.self)
        return tableView
    }()
    
    private let interactor: ChannelListBusinessLogic
    private let router: ChannelListRoutingLogic
    
    // MARK: - Initialization
    
    init(
        interactor: ChannelListBusinessLogic,
        router: ChannelListRoutingLogic,
        channelListDataSource: ChannelListDataSourceProtocol
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        var channelListDataSource = channelListDataSource
        channelListDataSource.tableView = self.tableView
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
        interactor.fetchProfile(request: ChannelListModel.FetchProfile.Request())
        interactor.fetchChannelList(request: ChannelListModel.ChannelList.Request())
    }
    
    // MARK: - Actions
    
    @objc
    private func openSettingsBarButtonTapped() {
        let route = ChannelListModel.Route.SettingsScreen(didChooseThemeHandler: { [weak self] theme in
            self?.interactor.updateTheme(request: ChannelListModel.UpdateTheme.Request(theme: theme))
        })
        router.navigateToSettings(route: route)
    }
    
    @objc
    private func addChannelBarButtonTapped() {
        interactor.requestAddChannelAlert(request: ChannelListModel.AddChannelAlert.Request())
    }
    
    @objc
    private func openProfileBarButtonTapped() {
        let route = ChannelListModel.Route.ProfileScreen(didChangeProfileHandler: { [weak self] profile in
            self?.interactor.updateProfile(request: ChannelListModel.UpdateProfile.Request(profile: profile))
        })
        router.navigateToProfile(route: route)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        navigationItem.leftBarButtonItems = [openSettingsBarButton, addChannelBarButton]
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
        title = "Channels"
    }
    
    private func customProfileBarButton(avatarData: Data) -> UIBarButtonItem {
        let size = Constants.profileBarButtonSize
        let iconData = avatarData.resizeImageFromImageData(to: size) // TEMP: Вынести из вью?
        
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        button.addTarget(self, action: #selector(self.openProfileBarButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(data: iconData), for: .normal)
        button.setCornerRadius(size.width / 2, continuousCurve: false)
        
        return UIBarButtonItem(customView: button)
    }
}

// MARK: - ChannelListDisplayLogic

extension ChannelListViewController: ChannelListDisplayLogic {
    
    func displayProfileData(viewModel: ChannelListModel.UpdateProfile.ViewModel) {
        navigationItem.rightBarButtonItem = customProfileBarButton(avatarData: viewModel.avatarImageData)
    }
    
    func displayFetchingChannelsError(viewModel: ChannelListModel.FetchingChannelsError.ViewModel) {
        showAlertController(title: viewModel.title, message: viewModel.message)
    }
    
    func displayAddChannelAlert(viewModel: ChannelListModel.AddChannelAlert.ViewModel) {
        let alertController = AddChannelAlertController(
            title: viewModel.title,
            message: nil,
            okActionHandler: { [weak self] channelName in
                self?.interactor.addNewChannel(request: ChannelListModel.NewChannel.Request(channelName: channelName))
            }
        )
        present(alertController, animated: true)
    }
    
    func displaySelectedChannel(viewModel: ChannelListModel.OpenChannel.ViewModel) {
        router.navigateToChannel(route: viewModel.route)
    }
}

// MARK: - UITableViewDelegate

extension ChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = ChannelListModel.OpenChannel.Request(indexPath: indexPath)
        interactor.openChannel(request: request)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            self?.interactor.deleteChannel(request: ChannelListModel.DeleteChannel.Request(indexPath: indexPath))
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
