//
//  Theme.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 14.10.2021.
//

import Foundation
import UIKit

enum Theme: String, Codable {
    case light
    case dark
    case champagne
    
    var backgroundColor: UIColor? {
        switch self {
        case .light:
            return Palette.lightBarColor
        case .dark:
            return Palette.darkBarColor
        case .champagne:
            return Palette.champagneBarColor
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .light, .champagne:
            return .black
        case .dark:
            return .white
        }
    }
}
