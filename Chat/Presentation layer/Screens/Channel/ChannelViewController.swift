//
//  ChannelViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 05.10.2021.
//

import UIKit

protocol ChannelDisplayLogic: AnyObject {
    func displayTheme(viewModel: ChannelModel.SetupTheme.ViewModel)
    func displayFetchingMessagesError(viewModel: ChannelModel.FetchingMessagesError.ViewModel)
    func displaySendMessage(viewModel: ChannelModel.SendMessage.ViewModel)
}

final class ChannelViewController: KeyboardNotificationsViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let bottomViewHeight: CGFloat = 80
        static let newMessageTexrFieldHeight: CGFloat = 32
        static let defaultBottomViewBottomSpacing: CGFloat = 0
    }
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.separatorStyle = .none
        tableView.registerCell(type: MessageCell.self)
        return tableView
    }()
    
    private lazy var bottomView = UIView().prepareForAutoLayout()
    
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
        let textField = NewMessageTextField { [weak self] text in
            self?.interactor.sendMessage(request: ChannelModel.SendMessage.Request(text: text))
        }
        textField.setCornerRadius(Constants.newMessageTexrFieldHeight / 2)
        textField.delegate = self
        return textField
    }()
    
    private lazy var addToMessageButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setImage(Icons.addToMessage, for: .normal)
        button.addTarget(self, action: #selector(didTapAddToMessageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableViewTapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        return tapGestureRecognizer
    }()
    
    private var bottomViewBottomConstraint: NSLayoutConstraint?
    private let interactor: ChannelBusinessLogic
    private let router: ChannelRoutingLogic
    
    // MARK: - Initialization
    
    init(
        interactor: ChannelBusinessLogic,
        router: ChannelRoutingLogic,
        channelDataSource: ChannelDataSourceProtocol,
        channelName: String
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        var channelDataSource = channelDataSource
        channelDataSource.tableView = tableView
        title = channelName
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
        interactor.fetchMessages(request: ChannelModel.FetchMessages.Request())
    }
    
    // MARK: - KeyboardNotificationsViewController
    
    override func keyboardWillShow(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { keyboardFrame in
            self.bottomViewBottomConstraint?.constant = -keyboardFrame.height - Constants.defaultBottomViewBottomSpacing
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        animateWithKeyboard(notification: notification) { _ in
            self.bottomViewBottomConstraint?.constant = -Constants.defaultBottomViewBottomSpacing
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapTableView() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapAddToMessageButton() {
        let route = ChannelModel.Route.ImagePicker(didPickImageHandler: { [weak self] url in
            self?.newMessageTextField.text = url.absoluteString
        })
        router.navigateToImagePicker(route: route)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(borderView)
        bottomView.addSubview(bottomViewStackView)
        bottomViewStackView.addArrangedSubviews(addToMessageButton, newMessageTextField)
        tableView.addGestureRecognizer(tableViewTapGestureRecognizer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
            addToMessageButton.widthAnchor.constraint(equalToConstant: 19)
        ])
        
        bottomViewBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomViewBottomConstraint?.isActive = true
    }
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        interactor.setupTheme(request: ChannelModel.SetupTheme.Request())
    }
}

// MARK: - ChannelDisplayLogic

extension ChannelViewController: ChannelDisplayLogic {
    
    func displayTheme(viewModel: ChannelModel.SetupTheme.ViewModel) {
        bottomView.backgroundColor = viewModel.theme.backgroundColor
    }
    
    func displayFetchingMessagesError(viewModel: ChannelModel.FetchingMessagesError.ViewModel) {
        showAlertController(title: viewModel.title, message: viewModel.message)
    }
    
    func displaySendMessage(viewModel: ChannelModel.SendMessage.ViewModel) {
        newMessageTextField.text = ""
        if tableView.numberOfRows(inSection: 0) != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChannelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        interactor.sendMessage(request: ChannelModel.SendMessage.Request(text: textField.text))
        return true
    }
}
