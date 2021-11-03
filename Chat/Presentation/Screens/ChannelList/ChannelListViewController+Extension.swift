//
//  ChannelListViewController+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 01.11.2021.
//

import UIKit

extension ChannelListViewController {
    
    final class AddChannelAlertController: UIAlertController {
        
        // MARK: - Private properties
        
        private var okAction: UIAlertAction?
        
        // MARK: - Initialization
        
        convenience init(title: String?, message: String?, okActionHandler: @escaping (String) -> Void) {
            self.init(title: title, message: message, preferredStyle: .alert)
            setupUI(okActionHandler: okActionHandler)
        }
        
        // MARK: - Actions
        
        @objc
        private func textFieldEditingChanged(sender: UITextField) {
            okAction?.isEnabled = isValidChannelName(text: sender.text)
        }
        
        // MARK: - Private methods
        
        private func setupUI(okActionHandler: @escaping (String) -> Void) {
            addTextField { textField in
                textField.placeholder = "Channel name"
                textField.addTarget(
                    self,
                    action: #selector(self.textFieldEditingChanged(sender:)),
                    for: .editingChanged
                )
            }
            
            okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                okActionHandler(self?.textFields?.first?.text ?? "")
            }
            okAction?.isEnabled = false
            if let okAction = okAction {
                addAction(okAction)
            }
            preferredAction = okAction
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
            addAction(cancelAction)
        }
        
        private func isValidChannelName(text: String?) -> Bool {
            if let text = text,
               !text.replacingOccurrences(of: " ", with: "").isEmpty {
                return true
            } else {
                return false
            }
        }
    }
}
