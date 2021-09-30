//
//  MainViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var openProfileButton: UIButton = {
        let button = UIButton().prepareForAutoLayout()
        button.setTitleColor(Palette.buttonTitleBlue, for: .normal)
        button.setTitle("Open Profile", for: .normal)
        button.addTarget(self, action: #selector(openProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func openProfileButtonTapped() {
        let profileVC = ProfileViewController()
        present(profileVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(openProfileButton)
        openProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openProfileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
