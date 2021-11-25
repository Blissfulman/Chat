//
//  MyMessageViewModel.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 25.11.2021.
//

import Foundation

protocol MyMessageViewModelProtocol {
    var text: String { get }
    var date: String { get }
    var isImageMessage: Bool { get }
    var messageURL: URL? { get }
}

final class MyMessageViewModel: MyMessageViewModelProtocol {
    
    // MARK: - Public properties
    
    let text: String
    let date: String
    let isImageMessage: Bool
    let messageURL: URL?
    
    // MARK: - Initialization
    
    init(text: String, date: String) {
        self.text = text
        self.date = date
        if let url = URL(string: text) {
            self.isImageMessage = true
            self.messageURL = url
        } else {
            self.isImageMessage = false
            self.messageURL = nil
        }
    }
}
