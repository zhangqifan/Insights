//
//  InsightsViewController.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 16:57.
//

import SwiftUI
import UIKit

/// Main view controller for the Insights tab, displaying analytics and calendar navigation
class InsightsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// View model managing the calendar date picker state
    private let calendarViewModel = InsightsCalendarDatePickerViewModel()
    
    /// Hosting controller for the calendar button SwiftUI view
    private var calendarButtonHostingController: UIHostingController<InsightsCalendarDatePickerButton>?
    
    /// Bar button item reference for popover presentation
    private var calendarBarButtonItem: UIBarButtonItem?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupActions()
    }
    
    // MARK: - Setup
    
    /// Configures the navigation bar with title and calendar button
    private func setupNavigationItems() {
        navigationItem.largeTitleDisplayMode = .never
        
        // Setup title label
        let titleLabel = UILabel()
        titleLabel.text = "Insights"
        titleLabel.textColor = .growMain
        titleLabel.font = .roundedFont(fontSize: 24, weight: .semibold)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        
        // Setup calendar button
        setupCalendarButton()
    }
    
    // MARK: - Calendar Button Setup
    
    /// Creates and configures the calendar picker button in the navigation bar
    private func setupCalendarButton() {
        let rootView = InsightsCalendarDatePickerButton(viewModel: calendarViewModel)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        hostingController.sizingOptions = [.intrinsicContentSize]
        
        let barButtonItem = UIBarButtonItem(customView: hostingController.view)
        navigationItem.rightBarButtonItem = barButtonItem
        
        calendarBarButtonItem = barButtonItem
        calendarButtonHostingController = hostingController
    }
    
    // MARK: - Actions
    
    /// Sets up tap gesture recognizer for the calendar button
    private func setupActions() {
        guard let buttonView = calendarButtonHostingController?.view else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarButtonTapped))
        buttonView.addGestureRecognizer(tapGesture)
        buttonView.isUserInteractionEnabled = true
    }
    
    /// Handles calendar button tap by presenting the date picker popover
    @objc private func calendarButtonTapped() {
        guard let currentMonth = calendarViewModel.currentMonth as Date? else { return }
        
        // Calculate minimum date (assumed to start from January 2022)
        let minimumDate = Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1)) ?? Date()
        
        // Create and present the date picker popover
        // Note: UIKit implementation is currently used (recommended for better performance)
        // To switch to SwiftUI implementation, use InsightsCalendarDatePickerViewControllerSwiftUI instead
        let popoverVC = InsightsCalendarDatePickerViewController(
            currentDate: currentMonth,
            minimumDate: minimumDate
        ) { [weak self] updatedDate in
            self?.calendarViewModel.updateMonth(using: updatedDate)
        }
        
        popoverVC.modalPresentationStyle = .popover
        popoverVC.popoverPresentationController?.sourceItem = calendarBarButtonItem
        popoverVC.popoverPresentationController?.delegate = self
        
        present(popoverVC, animated: true)
    }

}

// MARK: - UIPopoverPresentationControllerDelegate

extension InsightsViewController: UIPopoverPresentationControllerDelegate {
    /// Prevents adaptive presentation style changes, maintaining popover on all devices
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    /// Allows the popover to be dismissed by tapping outside
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    /// Prepares the popover by ensuring layout is complete before presentation
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let presentedVC = popoverPresentationController.presentedViewController as? InsightsCalendarDatePickerViewController {
            presentedVC.view.layoutIfNeeded()
        }
    }
}
