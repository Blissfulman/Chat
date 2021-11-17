//
//  ThemesViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 12.10.2021.
//

import UIKit

final class ThemesViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var topBarView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var centralStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()
    
    private lazy var lightThemeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Light theme", for: .normal)
        button.addTarget(self, action: #selector(lightThemeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var darkThemeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Dark theme", for: .normal)
        button.addTarget(self, action: #selector(darkThemeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var champagneThemeButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Champagne theme", for: .normal)
        button.addTarget(self, action: #selector(champagneThemeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let settingsService: SettingsService
    private let didChooseThemeHandler: (Theme) -> Void
    
    // MARK: - Initialization
    
    init(
        settingsService: SettingsService = ServiceLayer.shared.settingsService,
        didChooseThemeHandler: @escaping (Theme) -> Void
    ) {
        self.settingsService = settingsService
        self.didChooseThemeHandler = didChooseThemeHandler
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
    
    // MARK: - Actions
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func lightThemeButtonTapped() {
        let themeColors = Theme.light.themeColors
        view.backgroundColor = themeColors.backgroundColor
        didChooseThemeHandler(.light)
    }
    
    @objc
    private func darkThemeButtonTapped() {
        let themeColors = Theme.dark.themeColors
        view.backgroundColor = themeColors.backgroundColor
        didChooseThemeHandler(.dark)
    }
    
    @objc
    private func champagneThemeButtonTapped() {
        let themeColors = Theme.champagne.themeColors
        view.backgroundColor = themeColors.backgroundColor
        didChooseThemeHandler(.champagne)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(topBarView)
        topBarView.addSubview(closeButton)
        view.addSubview(centralStackView)
        centralStackView.addArrangedSubviews(lightThemeButton, darkThemeButton, champagneThemeButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            closeButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: -5),
            
            centralStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centralStackView.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    private func configureUI() {
        let theme = settingsService.getTheme()
        view.backgroundColor = theme.themeColors.backgroundColor
    }
}
