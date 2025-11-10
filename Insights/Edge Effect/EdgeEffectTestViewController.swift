//
//  EdgeEffectTestViewController.swift
//  Insights
//
//  Created by Shuhari on 2025-11-08.
//

import SwiftUI
import UIKit

/// View controller demonstrating edge effect with a collection view list
class EdgeEffectTestViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Types
    
    /// Section identifier for the collection view
    enum Section: Hashable {
        case main
    }
    
    /// Item model for the collection view
    struct Item: Hashable {
        let id: UUID
        let title: String
        let subtitle: String
        
        init(title: String, subtitle: String) {
            self.id = UUID()
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    // MARK: - Properties
    
    /// Collection view for displaying items
    private var collectionView: UICollectionView!
    
    /// Diffable data source for the collection view
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    /// Whether to use fake header (independent view) instead of real header
    private var useFakeHeader: Bool = false {
        didSet {
            if oldValue != useFakeHeader {
                handleFakeHeaderToggle()
            }
        }
    }
    
    /// Container view for fake header
    private var fakeHeaderContainer: UIView?
    
    /// Height of the fake header (calculated dynamically)
    private var fakeHeaderHeight: CGFloat = 132.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBg
        setupNavigationBar()
        setupCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        setupSettingsOverlay()
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
        label.text = "Edge Effect"
        label.font = .roundedFont(fontSize: 24, weight: .semibold)
        label.textColor = .growMain
        return label
    }()
    
    // MARK: - Collection View Setup
    
    /// Creates and configures the collection view with compositional layout
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .appBg
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        updateCollectionViewInsets()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Updates collection view content insets based on header mode
    private func updateCollectionViewInsets() {
        let topInset = useFakeHeader ? fakeHeaderHeight : 8
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 20, right: 0)
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    /// Creates the compositional layout for the collection view
    /// - Returns: A configured UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        // Only show real header when not using fake header
        configuration.headerMode = useFakeHeader ? .none : .supplementary
        configuration.showsSeparators = false // Remove cell separators
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    // MARK: - Data Source Configuration
    
    /// Configures the diffable data source with cell registration
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.subtitle
            content.textProperties.color = .growMain
            content.secondaryTextProperties.color = .growMain.withAlphaComponent(0.6)
            content.textProperties.font = .roundedFont(fontSize: 17, weight: .medium)
            content.secondaryTextProperties.font = .roundedFont(fontSize: 15, weight: .regular)
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listCell()
            backgroundConfig.backgroundColor = .tertiarySystemBackground
            backgroundConfig.cornerRadius = 16
            backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
            cell.backgroundConfiguration = backgroundConfig
        }
        
        // UIKit header registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<EdgeEffectHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.configure(
                title: "Real Section Header",
                subtitle: "Supports iOS 26 scroll edge effects"
            )
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    // MARK: - Snapshot Management
    
    /// Applies the initial snapshot with sample data
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        let items = [
            Item(title: "Edge Effect Item 1", subtitle: "This is a sample item"),
            Item(title: "Edge Effect Item 2", subtitle: "Another sample item"),
            Item(title: "Edge Effect Item 3", subtitle: "Testing compositional layout"),
            Item(title: "Edge Effect Item 4", subtitle: "Diffable data source example"),
            Item(title: "Edge Effect Item 5", subtitle: "UIKit collection view"),
            Item(title: "Edge Effect Item 6", subtitle: "Modern list design"),
            Item(title: "Edge Effect Item 7", subtitle: "Sample content here"),
            Item(title: "Edge Effect Item 8", subtitle: "More items to scroll"),
            Item(title: "Edge Effect Item 9", subtitle: "Keep scrolling down"),
            Item(title: "Edge Effect Item 10", subtitle: "Final sample item")
        ]
        
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Settings Overlay Setup
    
    /// Sets up the settings overlay view at the bottom of the screen
    private func setupSettingsOverlay() {
        addChild(settingsOverlayController)
        view.addSubview(settingsOverlayController.view)
        settingsOverlayController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            settingsOverlayController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsOverlayController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    /// Reconfigures the data source when header type changes
    private func reconfigureDataSource() {
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.main])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Fake Header Management
    
    /// Handles the toggle between real and fake header
    private func handleFakeHeaderToggle() {
        if useFakeHeader {
            // Switch to fake header: rebuild layout and setup fake header
            collectionView.setCollectionViewLayout(createLayout(), animated: false)
            view.layoutIfNeeded() // Force layout update
            setupFakeHeader() // This will call updateCollectionViewInsets internally
        } else {
            // Switch back to real header: remove fake header and rebuild layout
            removeFakeHeader()
            updateCollectionViewInsets()
            collectionView.setCollectionViewLayout(createLayout(), animated: false)
            reconfigureDataSource()
        }
    }
    
    /// Sets up the fake header view
    private func setupFakeHeader() {
        // Remove existing fake header if any
        removeFakeHeader()
        
        // Create container view
        let container = UIView()
        container.backgroundColor = .clear
        
        // Create UIKit header view
        let headerView = EdgeEffectHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.configure(
            title: "Fake Header (Independent View)",
            subtitle: "Does not trigger iOS 26 scroll edge effects"
        )
        
        container.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        // Calculate the actual height needed
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let calculatedSize = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        fakeHeaderHeight = calculatedSize.height
        
        // Add container to view hierarchy
        collectionView.addSubview(container)
        
        fakeHeaderContainer = container
        
        // Update collection view insets with the new height
        updateCollectionViewInsets()
        
        // Force layout update before positioning
        collectionView.layoutIfNeeded()
        
        // Update position after layout is complete
        updateFakeHeaderPosition()
    }
    
    /// Updates the fake header position - fixed at the top of collection view
    private func updateFakeHeaderPosition() {
        guard let headerContainer = fakeHeaderContainer else { return }
        
        // Position fake header at the top of the collection view (fixed position)
        headerContainer.frame = CGRect(
            x: 0,
            y: -fakeHeaderHeight,
            width: collectionView.bounds.width,
            height: fakeHeaderHeight
        )
    }
    
    /// Removes the fake header view
    private func removeFakeHeader() {
        fakeHeaderContainer?.removeFromSuperview()
        fakeHeaderContainer = nil
    }
    
    // MARK: - Lazy Properties
    
    /// Settings overlay controller for toggling header implementations
    lazy var settingsOverlayController: UIHostingController<some View> = {
        let rootView = EdgeEffectSettingsOverlay(
            useFakeHeader: Binding(
                get: { [weak self] in self?.useFakeHeader ?? false },
                set: { [weak self] newValue in self?.useFakeHeader = newValue }
            )
        )
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
}

// MARK: - UIScrollViewDelegate

extension EdgeEffectTestViewController {
    // No scroll delegate methods needed - fake header is now fixed at the top
}
