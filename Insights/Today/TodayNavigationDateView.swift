//
//  TodayNavigationDateView.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//

import SwiftUI

/// Date view for navigation bar, displays selected date as "Today", "Yesterday", or formatted date
struct TodayNavigationDateView: View {
    /// Layout mode for the date view
    enum LayoutMode {
        /// Uses frame with max width for title view (centered/leading alignment)
        case expanded
        /// Uses fixed size for bar button item (wraps content)
        case compact
    }
    
    /// Week view model containing the selected date
    @ObservedObject var viewModel: WeekViewModel
    
    /// Layout mode controlling how the view sizes itself
    var layoutMode: LayoutMode = .expanded
    
    /// Formatted display text based on the selected date
    private var displayText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: viewModel.selectedDate)
        
        if calendar.isDate(selectedDay, inSameDayAs: today) {
            return "Today"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  calendar.isDate(selectedDay, inSameDayAs: yesterday) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: viewModel.selectedDate)
        }
    }
    
    var body: some View {
        Text(displayText)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundStyle(.growMain)
            .contentTransition(.numericText())
            .animation(.snappy, value: displayText)
            .modifier(LayoutModifier(mode: layoutMode))
    }
}

/// View modifier that applies the appropriate layout based on the mode
private struct LayoutModifier: ViewModifier {
    let mode: TodayNavigationDateView.LayoutMode
    
    func body(content: Content) -> some View {
        switch mode {
        case .expanded:
            content.frame(maxWidth: .infinity, alignment: .leading)
        case .compact:
            content.fixedSize()
        }
    }
}

#Preview {
    TodayNavigationDateView(viewModel: WeekViewModel())
        .background(.appBg)
}

