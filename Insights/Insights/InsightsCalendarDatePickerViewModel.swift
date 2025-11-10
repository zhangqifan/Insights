//
//  InsightsCalendarDatePickerViewModel.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//

import SwiftUI
import Combine

/// View model managing the selected month/year for the Insights calendar date picker
class InsightsCalendarDatePickerViewModel: ObservableObject {
    /// Currently selected month (normalized to first day of month)
    @Published var currentMonth: Date
    
    // MARK: - Initialization
    
    /// Initializes the view model with a specific date or the current date
    /// - Parameter initialDate: The initial date to use, defaults to now
    init(initialDate: Date = .now) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: initialDate)
        self.currentMonth = calendar.date(from: components) ?? initialDate
    }
    
    // MARK: - Public Methods
    
    /// Updates the current month using a new date
    /// - Parameter date: The date containing the month/year to update to
    func updateMonth(using date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let updatingDate = calendar.date(from: components),
              currentMonth != updatingDate else { return }
        
        withAnimation(.snappy) {
            currentMonth = updatingDate
        }
    }
    
    /// Returns a formatted string representation of the current month
    /// - Parameter locale: The locale to use for formatting, defaults to current
    /// - Returns: A localized month string (e.g., "January" or "January 2024")
    func formattedMonth(locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = localizedFormatTemplate(from: currentMonth)
        return formatter.string(from: currentMonth)
    }
    
    // MARK: - Private Methods
    
    /// Checks if the given date is in the current year
    /// - Parameter date: The date to check
    /// - Returns: True if the date is in the current year
    private func isThisYear(with date: Date) -> Bool {
        Calendar.current.component(.year, from: date) == Calendar.current.component(.year, from: .now)
    }
    
    /// Returns the format template for displaying a date
    /// Shows only month name for current year, includes year otherwise
    /// - Parameter date: The date to get the format for
    /// - Returns: The format string ("MMMM" or "MMMM yyyy")
    private func localizedFormatTemplate(from date: Date) -> String {
        if isThisYear(with: date) {
            return "MMMM"
        } else {
            return "MMMM yyyy"
        }
    }
}

