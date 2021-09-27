//
//  AppDelegate.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 16.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Lifecycle methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let rootViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        if GlobalFlags.loggingEnabled { print(#function) }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if GlobalFlags.loggingEnabled { print("Application moved from active to inactive:", #function) }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if GlobalFlags.loggingEnabled { print("Application moved from inactive to active:", #function) }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if GlobalFlags.loggingEnabled { print("Application moved from background to foreground:", #function) }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if GlobalFlags.loggingEnabled { print("Application moved from foreground to background:", #function) }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if GlobalFlags.loggingEnabled { print(#function) }
    }
}
