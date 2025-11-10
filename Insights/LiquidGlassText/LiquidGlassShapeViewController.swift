//
//  LiquidGlassShapeViewController.swift
//  Insights
//
//  Created on November 6, 2025.
//

import SwiftUI
import UIKit

/// View controller demonstrating the Liquid Glass text effect with mesh gradient
class LiquidGlassShapeViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBg
        setupNavigationBar()
        setupSwiftUIView()
    }
    
    // MARK: - Navigation Bar Setup
    
    /// Configures the navigation bar with title
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem?.hidesSharedBackground = true
    }
    
    /// Title label for the navigation bar
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Liquid Glass Shape"
        label.font = .roundedFont(fontSize: 24, weight: .semibold)
        label.textColor = .growMain
        return label
    }()
    
    // MARK: - SwiftUI View Setup
    
    /// Sets up the SwiftUI view containing the mesh gradient effect
    private func setupSwiftUIView() {
        let rootView = MeshGradientView()
        
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
