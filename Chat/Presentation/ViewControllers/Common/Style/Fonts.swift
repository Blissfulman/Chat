//
//  Fonts.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 29.09.2021.
//

enum Fonts {
    static let navBarTitle = UIFont(name: "SF Pro Display Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
    static let navBarTitleLarge = UIFont(name: "SF Pro Display Bold", size: 37)
        ?? .systemFont(ofSize: 37, weight: .bold)
    
    static let title = UIFont(name: "SF Pro Display Bold", size: 26) ?? .systemFont(ofSize: 26, weight: .bold)
    static let subTitle = UIFont(name: "SF Pro Display Bold", size: 24) ?? .systemFont(ofSize: 24, weight: .bold)
    static let buttonTitle = UIFont(name: "SF Pro Text Regular", size: 17) ?? .systemFont(ofSize: 17)
    static let body = UIFont(name: "SF Pro Text Regular", size: 16) ?? .systemFont(ofSize: 16)
    
    static let channelCellName = UIFont(name: "SF Pro Text Semibold", size: 15)
        ?? .systemFont(ofSize: 15, weight: .semibold)
    static let channelCellDate = UIFont(name: "SF Pro Text Regular", size: 15)
        ?? .systemFont(ofSize: 15)
    static let channelCellReadMessage = UIFont(name: "SF Pro Text Regular", size: 13)
        ?? .systemFont(ofSize: 13)
    static let channelCellUnreadMessage = UIFont(name: "SF Pro Text Bold", size: 13)
        ?? .systemFont(ofSize: 13, weight: .bold)
    static let channelCellNoMessage = UIFont(name: "SF Pro Text Regular Italic", size: 13)
        ?? .systemFont(ofSize: 13)
    
    static let messageCellText = UIFont(name: "SF Pro Text Regular", size: 16) ?? .systemFont(ofSize: 16)
    static let messageCellDate = UIFont(name: "SF Pro Text Regular", size: 11) ?? .systemFont(ofSize: 11)
}
