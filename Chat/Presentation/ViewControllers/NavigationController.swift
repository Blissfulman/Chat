//
//  NavigationController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 14.10.2021.
//

import Foundation

final class NavigationController: UINavigationController {
    
    // MARK: - Static methods
    
    static func setupAppearance(for theme: Theme = .light) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.font: Fonts.navBarTitle]
            appearance.largeTitleTextAttributes = [.font: Fonts.navBarTitleLarge]
            
            let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self])
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.prefersLargeTitles = true
        }
    }
    
    static func updateColors(for theme: Theme) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.themeColors.backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: theme.themeColors.fontColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.themeColors.fontColor]
            
            let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self])
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
