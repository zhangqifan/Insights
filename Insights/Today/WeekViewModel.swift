//
//  WeekViewModel.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//

import SwiftUI
import Combine

/// View model managing week dates and date selection for the Today view
class WeekViewModel: ObservableObject {
    /// Array of dates representing the current week (Sunday to Saturday)
    @Published var weekDates: [Date] = []
    
    /// Currently selected date
    @Published var selectedDate: Date = Date()
    
    // MARK: - Initialization
    
    init() {
        updateWeekDates()
    }
    
    // MARK: - Private Methods
    
    /// Updates the week dates array to contain the current week's dates
    private func updateWeekDates() {
        let calendar = Calendar.current
        let today = Date()
        
        // Get the start of the week (Sunday)
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return
        }
        
        // Generate 7 days starting from the week start
        weekDates = (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: weekStart)
        }
        
        selectedDate = today
    }
    
    // MARK: - Public Methods
    
    /// Selects a specific date
    /// - Parameter date: The date to select
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    /// Checks if a given date is the currently selected date
    /// - Parameter date: The date to check
    /// - Returns: True if the date is selected, false otherwise
    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    /// Checks if a given date is today or in the past
    /// - Parameter date: The date to check
    /// - Returns: True if the date is today or earlier, false otherwise
    func isTodayOrPast(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let compareDate = calendar.startOfDay(for: date)
        return compareDate <= today
    }
}


