//
//  Router.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04.
//

import UIKit
import Combine
import SwiftUI

/// Central router responsible for managing navigation and view controller creation throughout the app
@MainActor
public class Router: ObservableObject {
    
    // MARK: - Properties
    
    /// Current route state. Set this property to trigger navigation from SwiftUI or UIKit
    @Published public var route: Route = .none
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - ViewController Factory
    
    /// Creates a view controller for the specified route
    /// - Parameter route: The destination route
    /// - Returns: The corresponding view controller, or nil if the route is `.none` or invalid
    func createViewController(for route: Route) -> UIViewController? {
        switch route {
        case .none:
            return nil
        case .dailyRoutine:
            return DailyRoutineViewController()
        }
    }
    
    // MARK: - Navigation Helpers
    
    /// Returns the current navigation controller in the view hierarchy
    /// - Returns: The active UINavigationController, or nil if not found
    func getCurrentNavigationController() -> UINavigationController? {
        return UIApplication.topViewController()?.navigationController
    }
    
    /// Returns the topmost visible view controller
    /// - Returns: The currently visible UIViewController, or nil if not found
    func getTopViewController() -> UIViewController? {
        return UIApplication.topViewController()
    }
}

// MARK: - UIApplication Extension

extension UIApplication {
    /// Recursively finds and returns the topmost view controller in the view hierarchy
    /// - Parameter base: The base view controller to start searching from. Defaults to root view controller if nil.
    /// - Returns: The topmost visible view controller, or nil if not found
    static func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.rootViewController
        
        // Handle navigation controller
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        // Handle tab bar controller
        if let tab = base as? UITabBarController,
           let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        
        // Handle presented view controller
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
