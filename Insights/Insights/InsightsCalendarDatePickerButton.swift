//
//  InsightsCalendarDatePickerButton.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//

import SwiftUI

/// Calendar date picker button displaying the current month/year with a chevron indicator
struct InsightsCalendarDatePickerButton: View {
    /// View model managing the selected month
    @ObservedObject private var viewModel: InsightsCalendarDatePickerViewModel
    
    /// Current locale for formatting
    @Environment(\.locale) private var locale
    
    // MARK: - Initialization
    
    init(viewModel: InsightsCalendarDatePickerViewModel) {
        self.viewModel = viewModel
    }
    
    /// Formatted month/year text
    private var displayText: String {
        viewModel.formattedMonth(locale: locale)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(displayText)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.growBlue)
                .contentTransition(.numericText())
            
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.growBlue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .animation(.snappy, value: displayText)
    }
}

#Preview {
    InsightsCalendarDatePickerButton(viewModel: InsightsCalendarDatePickerViewModel())
        .background(.appBg)
}

