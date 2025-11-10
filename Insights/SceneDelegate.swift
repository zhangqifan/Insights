//
//  SceneDelegate.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 16:23.
//

import UIKit

/// Manages the scene lifecycle and window configuration
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = GrowTabBarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Release any resources associated with this scene that can be re-created
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks that were paused when the scene was inactive
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing tasks and prepare for temporary interruptions
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo the changes made when entering the background
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release shared resources
    }
}

