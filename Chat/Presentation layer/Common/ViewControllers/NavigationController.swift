//
//  NavigationController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 14.10.2021.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    
    // MARK: - Static methods
    
    static func setupAppearance(for theme: Theme) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.font: Fonts.navBarTitle]
            appearance.largeTitleTextAttributes = [.font: Fonts.navBarTitleLarge]
            
            let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self])
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.prefersLargeTitles = true
            
            updateColors(for: theme)
        }
    }
    
    static func updateColors(for theme: Theme) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.fontColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.fontColor]
            
            let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self])
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
