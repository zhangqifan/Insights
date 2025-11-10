//
//  TodayViewController.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 16:57.
//

import Combine
import SwiftUI
import UIKit

/// Main view controller for the Today tab, displaying daily routines and week selection
class TodayViewController: UIViewController {
    
    // MARK: - Types
    
    /// Defines how the date header is displayed in the navigation bar
    private enum NavigationDateDisplayMode {
        /// Display date as the navigation bar's title view (centered)
        case titleView
        
        /// Display date as a left bar button item
        case barButtonItem
        
        /// Returns true if the current mode is titleView
        var isTitleView: Bool {
            if case .titleView = self { return true }
            return false
        }
    }
    
    // MARK: - Properties
    
    /// View model managing week dates and selection
    private let weekViewModel = WeekViewModel()
    
    /// Storage for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Hosting controller for the date view
    private var dateHostingController: UIHostingController<TodayNavigationDateView>?
    
    /// Current display mode for the date header
    private var displayMode: NavigationDateDisplayMode = .barButtonItem {
        didSet {
            updateNavigationBar(mode: displayMode)
        }
    }
    
    /// Boolean binding for display mode, used by settings overlay
    private var dateItemSetAsTitleView: Bool {
        get { displayMode.isTitleView }
        set { displayMode = newValue ? .titleView : .barButtonItem }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupSettingsOverlay()
        setupNavigationItems()
    }
    
    // MARK: - Setup
    
    /// Configures the navigation bar items and display mode
    private func setupNavigationItems() {
        navigationItem.largeTitleDisplayMode = .never
        updateNavigationBar(mode: displayMode)
    }
    
    /// Sets up the main content view
    private func setupContent() {
        addChildHostingController(contentHostingController, fillSuperview: true)
    }
    
    /// Sets up the settings overlay view at the bottom of the screen
    private func setupSettingsOverlay() {
        addChild(settingsOverlayController)
        view.addSubview(settingsOverlayController.view)
        settingsOverlayController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            settingsOverlayController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsOverlayController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsOverlayController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Navigation Bar Configuration
    
    /// Updates the navigation bar based on the specified display mode
    /// - Parameter mode: The display mode to apply
    private func updateNavigationBar(mode: NavigationDateDisplayMode) {
        switch mode {
        case .titleView:
            setupTitleViewMode()
        case .barButtonItem:
            setupBarButtonItemMode()
        }
    }
    
    /// Configures the navigation bar to display the date as the title view
    private func setupTitleViewMode() {
        let hostingController = makeHostingController(layoutMode: .expanded)
        hostingController.view.backgroundColor = .systemTeal
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        
        navigationItem.titleView = hostingController.view
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        dateHostingController = hostingController
    }
    
    /// Configures the navigation bar to display the date as a bar button item
    private func setupBarButtonItemMode() {
        let hostingController = makeHostingController(layoutMode: .compact)
        hostingController.view.backgroundColor = .systemOrange
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let barButtonItem = UIBarButtonItem(customView: hostingController.view)
        barButtonItem.hidesSharedBackground = true
        
        navigationItem.leftBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = nil
        
        dateHostingController = hostingController
    }
    
    // MARK: - Hosting Controller Factory
    
    /// Creates a hosting controller for the date view with the specified layout mode
    /// - Parameter layoutMode: The layout mode for the date view
    /// - Returns: A configured UIHostingController with TodayNavigationDateView
    private func makeHostingController(layoutMode: TodayNavigationDateView.LayoutMode) -> UIHostingController<TodayNavigationDateView> {
        let rootView = TodayNavigationDateView(viewModel: weekViewModel, layoutMode: layoutMode)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.sizingOptions = [.intrinsicContentSize]
        return hostingController
    }
    
    /// Adds a child hosting controller to the view hierarchy
    /// - Parameters:
    ///   - hostingController: The hosting controller to add
    ///   - fillSuperview: Whether to fill the entire superview
    private func addChildHostingController(_ hostingController: UIViewController, fillSuperview: Bool) {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        if fillSuperview {
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    // MARK: - Lazy Properties
    
    /// Main content hosting controller displaying the Today content view
    lazy var contentHostingController: UIHostingController<some View> = {
        let rootView = TodayContentView()
            .environmentObject(UIApplication.router)
            .environmentObject(weekViewModel)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    /// Settings overlay controller for toggling display modes
    lazy var settingsOverlayController: UIHostingController<some View> = {
        let rootView = TodaySettingsOverlay(setAsTitleView: Binding(
            get: { [weak self] in self?.dateItemSetAsTitleView ?? false },
            set: { [weak self] newValue in self?.dateItemSetAsTitleView = newValue }
        ))
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
}
