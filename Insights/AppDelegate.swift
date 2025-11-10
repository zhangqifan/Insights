//
//  AppDelegate.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 16:23.
//

import UIKit
import Combine

/// Main application delegate responsible for app lifecycle and global router management
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    /// Global router instance for handling navigation throughout the app
    let router = Router()
    
    /// Storage for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRouter()
        return true
    }
    
    // MARK: - Router Setup
    
    /// Configures the router to observe route changes and handle navigation
    private func setupRouter() {
        router.$route
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] route in
                self?.handleRoute(route)
            }
            .store(in: &cancellables)
    }
    
    /// Handles route changes by resetting the route and executing navigation
    /// - Parameter route: The route to navigate to
    private func handleRoute(_ route: Route) {
        guard route != .none else { return }
        
        Task { @MainActor in
            router.route = .none
        }
        
        Task { @MainActor in
            executeNavigation(for: route)
        }
    }
    
    /// Executes the navigation to a specific route by creating and pushing the view controller
    /// - Parameter route: The destination route
    @MainActor
    private func executeNavigation(for route: Route) {
        guard let viewController = router.createViewController(for: route) else {
            return
        }
        
        guard let navigationController = router.getCurrentNavigationController() else {
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Release any resources specific to the discarded scenes
    }
}

