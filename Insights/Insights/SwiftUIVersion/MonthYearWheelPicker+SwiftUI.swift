//
//  MonthYearWheelPicker+SwiftUI.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//
//  NOTE: This is a SwiftUI wrapper for MonthYearWheelPicker.
//  The project currently uses the UIKit version directly.
//  This file is kept as reference and alternative implementation.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Wrapper

/// SwiftUI wrapper for the UIKit MonthYearWheelPicker
public struct MonthYearWheelPickerViewSwiftUI: UIViewRepresentable {
    /// Currently selected date
    @Binding var selectedDate: Date
    
    /// Minimum selectable date
    let minimumDate: Date
    
    /// Maximum selectable date
    let maximumDate: Date
    
    /// Height of each picker row
    let rowHeight: CGFloat
    
    /// Intrinsic height of the picker
    let intrinsicHeight: CGFloat
    
    /// Callback invoked when date changes
    let onDateChanged: ((Date) -> Void)?
    
    // MARK: - Initialization
    
    public init(
        selectedDate: Binding<Date>,
        minimumDate: Date,
        maximumDate: Date,
        rowHeight: CGFloat = 34,
        intrinsicHeight: CGFloat = 173,
        onDateChanged: ((Date) -> Void)? = nil
    ) {
        self._selectedDate = selectedDate
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.rowHeight = rowHeight
        self.intrinsicHeight = intrinsicHeight
        self.onDateChanged = onDateChanged
    }
    
    // MARK: - UIViewRepresentable
    
    /// Creates the underlying UIKit picker view
    public func makeUIView(context: Context) -> MonthYearWheelPicker {
        let picker = MonthYearWheelPicker()
        picker.minimumDate = minimumDate
        picker.maximumDate = maximumDate
        picker.rowHeight = rowHeight
        picker.intrinsicHeight = intrinsicHeight
        picker.intrinsicWidth = picker.recommendedIntrinsicWidth()
        picker.setDate(selectedDate, animated: false)
        
        picker.onDateSelected = { month, year in
            context.coordinator.dateChanged(month: month, year: year)
        }
        
        return picker
    }
    
    /// Updates the UIKit picker when SwiftUI state changes
    public func updateUIView(_ uiView: MonthYearWheelPicker, context: Context) {
        if uiView.date != selectedDate {
            uiView.setDate(selectedDate, animated: true)
        }
        if uiView.minimumDate != minimumDate {
            uiView.minimumDate = minimumDate
        }
        if uiView.maximumDate != maximumDate {
            uiView.maximumDate = maximumDate
        }
    }
    
    /// Creates the coordinator to handle picker delegate callbacks
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Coordinator class to bridge UIKit delegate callbacks to SwiftUI
    public class Coordinator: NSObject {
        /// Reference to the parent SwiftUI view
        let parent: MonthYearWheelPickerViewSwiftUI
        
        init(_ parent: MonthYearWheelPickerViewSwiftUI) {
            self.parent = parent
        }
        
        /// Handles date selection changes from the picker
        /// - Parameters:
        ///   - month: The selected month (1-12)
        ///   - year: The selected year
        func dateChanged(month: Int, year: Int) {
            guard let newDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) else {
                return
            }
            DispatchQueue.main.async {
                self.parent.selectedDate = newDate
                self.parent.onDateChanged?(newDate)
            }
        }
    }
}

