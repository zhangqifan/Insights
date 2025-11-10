//
//  TodayWeekPickerView.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05.
//

import SwiftUI

/// Week picker view displaying 7 days (Sunday to Saturday) with selection capability
struct TodayWeekPickerView: View {
    /// Week view model managing dates and selection
    @EnvironmentObject var viewModel: WeekViewModel
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(viewModel.weekDates, id: \.self) { date in
                TodayWeekDayView(
                    date: date,
                    isSelected: viewModel.isSelected(date),
                    isTodayOrPast: viewModel.isTodayOrPast(date),
                    onTap: { viewModel.selectDate(date) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
}

/// Individual day view within the week picker
struct TodayWeekDayView: View {
    /// The date this view represents
    let date: Date
    
    /// Whether this date is currently selected
    let isSelected: Bool
    
    /// Whether this date is today or in the past
    let isTodayOrPast: Bool
    
    /// Callback when the day is tapped
    let onTap: () -> Void
    
    /// Day number string (1-31)
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    /// Whether this day can be selected (only today or past days are selectable)
    private var isEnabled: Bool {
        isTodayOrPast
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Day number
            Text(dayString)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? .white : (isEnabled ? .growMain : Color(uiColor: .tertiaryLabel)))
                .frame(height: 16)
                .padding(.horizontal, 6)
                .padding(.vertical, 0.5)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.growBlue : Color.clear)
                )
            
            // Day indicator circle
            Circle()
                .fill(isTodayOrPast ? Color.gray.opacity(0.5) : Color(uiColor: .tertiarySystemFill))
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color(uiColor: .secondarySystemFill), lineWidth: 0.5)
                }
                .frame(width: 36, height: 36)
                .padding(.bottom, 4)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .disabled(!isEnabled)
    }
}

#Preview {
    TodayWeekPickerView()
        .environmentObject(WeekViewModel())
        .background(.appBg)
}

