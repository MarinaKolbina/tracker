//
//  AppDelegate.swift
//  Tracker
//
//  Created by Marina Kolbina on 27/03/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        var window = UIWindow(frame: UIScreen.main.bounds)
//        
//        // Create a view controller
//        let viewController = TabBarController()
//        
//        // Set the view controller as the window's root view controller
//        window.rootViewController = viewController
//        
//        // Make the window visible
//        window.makeKeyAndVisible()
        
        return true
    }
        
//        // Create an instance of your launch screen view controller
//        let splashViewController = SplashViewController()
//
//        // Set the launch screen view controller as the root view controller of the window
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = splashViewController
//        window.makeKeyAndVisible()
//
//        // Wait for 2 seconds before showing the tab bar controller
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            // Create an instance of your tab bar controller
//            let tabBarController = TabBarController()
//
//            // Set the tab bar controller as the root view controller of the window
//            window.rootViewController = tabBarController
//        }
//
//        return true
//
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

