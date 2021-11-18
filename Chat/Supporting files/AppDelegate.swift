//
//  AppDelegate.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Lifecycle methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initialConfigure()
        
        let mainViewController = ChannelListAssembly.assembly()
        let navigationController = NavigationController(rootViewController: mainViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let contentManager: ContentManager = ServiceLayer.shared.contentManager
        contentManager.saveData()
    }
    
    // MARK: - Private methods
    
    private func initialConfigure() {
        FirebaseApp.configure()
        let settingsManager: SettingsManager = ServiceLayer.shared.settingsManager
        settingsManager.loadMySenderID()
        NavigationController.setupAppearance(for: settingsManager.theme)
    }
}
