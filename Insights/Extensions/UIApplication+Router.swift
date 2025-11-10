//
//  UIApplication+Router.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04.
//

import UIKit

extension UIApplication {
    /// Returns the global router instance from the AppDelegate
    /// - Returns: The shared Router instance for app-wide navigation
    static var router: Router {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Failed to get AppDelegate")
            return Router()
        }
        return appDelegate.router
    }
}

