//
//  Theme.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 14.10.2021.
//

import Foundation

enum Theme {
    case light
    case dark
    case champagne
    
    var themeColors: (backgroundColor: UIColor?, fontColor: UIColor) {
        switch self {
        case .light:
            return (backgroundColor: Palette.lightBarColor, fontColor: .black)
        case .dark:
            return (backgroundColor: Palette.darkBarColor, fontColor: .white)
        case .champagne:
            return (backgroundColor: Palette.champagneBarColor, fontColor: .black)
        }
    }
}
