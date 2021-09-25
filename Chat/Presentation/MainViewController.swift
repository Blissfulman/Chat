//
//  MainViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var openSecondScreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Second screen", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(openSecondScreenButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if GlobalFlags.loggingEnabled { print(#fileID, #function) }
    }
    
    // MARK: - Actions
    
    @objc
    private func openSecondScreenButtonTapped() {
        let secondVC = SecondViewController()
        navigationController?.show(secondVC, sender: nil)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(openSecondScreenButton)
        openSecondScreenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openSecondScreenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
