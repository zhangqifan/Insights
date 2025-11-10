//
//  InsightsCalendarDatePicker+SwiftUI.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//
//  NOTE: This is a SwiftUI implementation of the date picker.
//  The project currently uses the UIKit version (InsightsCalendarDatePicker.swift).
//  This file is kept as reference and alternative implementation.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View

/// SwiftUI version of the calendar date picker popover
public struct InsightsCalendarDatePickerSwiftUI: View {
    /// Currently selected date
    @State private var currentDate: Date
    
    /// Dismiss action from environment
    @Environment(\.dismiss) private var dismiss
    
    /// Callback invoked when date changes
    private var onDateChanged: ((Date) -> Void)?
    
    /// Minimum selectable date
    private let minimumDate: Date
    
    // MARK: - Initialization
    
    public init(currentDate: Date, minimumDate: Date = Date(), onDateChanged: ((Date) -> Void)?) {
        self._currentDate = State(initialValue: currentDate)
        self.minimumDate = minimumDate
        self.onDateChanged = onDateChanged
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            topBarView
            datePicker
            actions
        }
        .fixedSize()
        .padding(14)
    }
}

extension InsightsCalendarDatePickerSwiftUI {
    /// Top bar containing title and close button
    @ViewBuilder
    private var topBarView: some View {
        HStack {
            Text("Time travel")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(uiColor: .growMain))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 6)
            
            Button {
                dismiss.callAsFunction()
            } label: {
                Circle()
                    .fill(Color(uiColor: .quaternarySystemFill))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .growMain))
                    }
                    .contentShape(Circle())
            }
        }
    }
    
    /// Month/year picker wheel
    @ViewBuilder
    private var datePicker: some View {
        MonthYearWheelPickerViewSwiftUI(
            selectedDate: .constant(currentDate),
            minimumDate: minimumDate,
            maximumDate: .now,
            rowHeight: 34,
            intrinsicHeight: 173
        ) { newDate in
            currentDate = newDate
        }
    }
    
    /// Action buttons (Now and Done)
    @ViewBuilder
    private var actions: some View {
        GeometryReader { proxy in
            HStack(spacing: 14) {
                Button {
                    onDateChanged?(.now)
                    dismiss.callAsFunction()
                } label: {
                    Text("Now")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.growBlue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(uiColor: .quaternarySystemFill))
                        )
                }
                .frame(width: (proxy.size.width - 14.0) / 2.0)
                
                Button {
                    onDateChanged?(currentDate)
                    dismiss.callAsFunction()
                } label: {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.growBlue)
                        )
                }
                .frame(width: (proxy.size.width - 14.0) / 2.0)
            }
        }
        .frame(height: 44)
    }
}

// MARK: - UIKit Wrapper for SwiftUI Version

/// UIKit wrapper view controller for the SwiftUI date picker implementation
public class InsightsCalendarDatePickerViewControllerSwiftUI: UIViewController {
    
    // MARK: - Properties
    
    /// Initially selected date
    let currentDate: Date
    
    /// Minimum selectable date
    let minimumDate: Date
    
    /// Callback invoked when date changes
    let onDateChanged: ((Date) -> Void)?
    
    // MARK: - Initialization
    
    public init(currentDate: Date, minimumDate: Date = Date(), onDateChanged: ((Date) -> Void)?) {
        self.currentDate = currentDate
        self.minimumDate = minimumDate
        self.onDateChanged = onDateChanged
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // Cleanup handled automatically
    }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(datePickerHostingController)
        view.addSubview(datePickerHostingController.view)
        datePickerHostingController.didMove(toParent: self)
        
        datePickerHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePickerHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            datePickerHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePickerHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePickerHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        calculatePreferredContentSize()
    }
    
    // MARK: - Layout
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            self?.calculatePreferredContentSize()
        }
    }
    
    /// Calculates and sets the preferred content size for the popover
    private func calculatePreferredContentSize() {
        let targetSize = CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        let fittingSize = datePickerHostingController.view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        if fittingSize.width <= 0 || fittingSize.height <= 0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let intrinsicSize = self.datePickerHostingController.view.intrinsicContentSize
                if intrinsicSize.width > 0 && intrinsicSize.height > 0 {
                    self.preferredContentSize = intrinsicSize
                }
            }
        } else {
            preferredContentSize = fittingSize
        }
    }
    
    /// Internal handler for date changes
    /// - Parameter date: The newly selected date
    private func _onDateChangedAction(_ date: Date) {
        onDateChanged?(date)
        dismiss(animated: true)
    }
    
    /// Hosting controller for the SwiftUI date picker view
    lazy var datePickerHostingController: UIHostingController<InsightsCalendarDatePickerSwiftUI> = {
        let rootView = InsightsCalendarDatePickerSwiftUI(
            currentDate: currentDate,
            minimumDate: minimumDate
        ) { [weak self] date in
            self?._onDateChangedAction(date)
        }
        let hosting = UIHostingController(rootView: rootView)
        hosting.view.backgroundColor = .clear
        return hosting
    }()
}

#Preview {
    InsightsCalendarDatePickerSwiftUI(currentDate: .now, onDateChanged: nil)
}

