//
//  ProgressView.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 21.10.2021.
//

import UIKit

final class ProgressView: UIView {
    
    // MARK: - Private properties
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView().prepareForAutoLayout()
        activityIndicator.style = .whiteLarge
        activityIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.setCornerRadius(25)
        return activityIndicator
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func show() {
        activityIndicator.startAnimating()
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        prepareForAutoLayout()
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
