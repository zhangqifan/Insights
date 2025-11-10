//
//  GrowTabBarController.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 16:31.
//

import UIKit

/// Represents a tab item in the main tab bar
enum TabItem: String, Hashable, CaseIterable {
    case today = "Today"
    case insights = "Insights"
    case shape = "LG Shape"
    case edgeEffect = "Edge Effect"

    /// Returns the icon image for the tab item
    var tabSymbol: UIImage? {
        switch self {
        case .today: UIImage(named: "tab-today-symbol")
        case .insights: UIImage(named: "tab-insight-symbol")
        case .shape: UIImage(systemName: "text.rectangle.fill")
        case .edgeEffect: UIImage(systemName: "square.on.square.squareshape.controlhandles")
        }
    }

    /// Creates and returns the view controller for the tab item, wrapped in a navigation controller
    var controller: UIViewController {
        switch self {
        case .today: UINavigationController(rootViewController: TodayViewController())
        case .insights: UINavigationController(rootViewController: InsightsViewController())
        case .shape: UINavigationController(rootViewController: LiquidGlassShapeViewController())
        case .edgeEffect: UINavigationController(rootViewController: EdgeEffectTestViewController())
        }
    }
}

/// Main tab bar controller for the app, managing Today, Insights, and Liquid Glass Shape tabs
class GrowTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBg
        setupTabItems()
    }

    // MARK: - Setup
    
    /// Configures all tab items and tab bar appearance
    private func setupTabItems() {
        // Setup tab items
        for item in TabItem.allCases {
            let controller = item.controller
            addChild(controller)
            controller.didMove(toParent: self)

            controller.tabBarItem.image = item.tabSymbol
            controller.tabBarItem.selectedImage = item.tabSymbol
            controller.tabBarItem.title = item.rawValue
        }

        // Configure tab bar appearance
        let normalTint = UIColor.tabBarNormalTint
        let selectedTint = UIColor.tabBarSelectedTint

        let appearance = UITabBarAppearance(idiom: .phone)
        
        // Stacked layout (portrait)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalTint]
        appearance.stackedLayoutAppearance.normal.iconColor = normalTint
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedTint]
        appearance.stackedLayoutAppearance.selected.iconColor = selectedTint

        // Inline layout
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalTint]
        appearance.inlineLayoutAppearance.normal.iconColor = normalTint
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedTint]
        appearance.inlineLayoutAppearance.selected.iconColor = selectedTint

        // Compact inline layout (landscape)
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalTint]
        appearance.compactInlineLayoutAppearance.normal.iconColor = normalTint
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedTint]
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedTint
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
