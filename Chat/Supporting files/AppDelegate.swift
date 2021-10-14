//
//  AppDelegate.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Lifecycle methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NavigationController.setupAppearance()
        
        let mainViewController = ConversationListViewController()
        let navigationController = NavigationController(rootViewController: mainViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
