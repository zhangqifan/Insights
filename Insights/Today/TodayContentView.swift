//
//  TodayContentView.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04 17:51.
//

import SwiftUI

/// Main content view for the Today tab, displaying progress, week picker, and daily routines
struct TodayContentView: View {
    /// Current progress value (0.0 to 1.0)
    @State private var progress: Double = 0.0
    
    /// App router for navigation
    @EnvironmentObject private var appRouter: Router

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TodayWeekPickerView()
                progressSection
                todayTitlesView
                habitBlocks
            }
            .padding(.vertical)
        }
        .scrollIndicators(.hidden)
    }
}

extension TodayContentView {
    /// Circular progress indicator showing completion percentage
    @ViewBuilder
    private var progressSection: some View {
        HStack(alignment: .center, spacing: 35) {
            Image(systemName: "info.circle")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.gray)

            ZStack {
                Circle()
                    .trim(from: 0, to: CGFloat(progress) * 0.75)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.8),
                                Color.pink.opacity(0.8),
                                Color.purple.opacity(0.8)
                            ]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )

                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        Color(uiColor: .quaternarySystemFill),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
            }
            .rotationEffect(.degrees(135))
            .aspectRatio(1.0, contentMode: .fill)
            .overlay(alignment: .bottom) {
                Circle()
                    .fill(Color(uiColor: .quaternarySystemFill))
                    .overlay {
                        Circle()
                            .stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 1)
                    }
                    .frame(width: 60, height: 60)
                    .offset(y: 10)
            }
            .overlay {
                VStack(spacing: 0) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.growMain)
                        .contentTransition(.numericText())
                    
                    Text("Perfect Day")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
            }

            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 40)
        .onAppear {
            withAnimation(.smooth) {
                progress = 0.45
            }
        }
    }
    
    /// Title and description section showing fitness status
    @ViewBuilder
    private var todayTitlesView: some View {
        VStack(spacing: 2) {
            Text("Your fitness is on the rise.")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.growMain)
            
            Text("Great job, Taylor! You have a moderately active lifestyle. Remember to give your body ample time to recover, as you may be pushing it too far.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color(uiColor: .secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
    }
    
    /// Grid of habit blocks for daily routine
    @ViewBuilder
    private var habitBlocks: some View {
        VStack(spacing: 4) {
            // Header section
            HStack {
                Text("Daily Routine")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.growMain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    appRouter.route = .dailyRoutine
                } label: {
                    Text("All\(Image(systemName: "chevron.right"))")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.growBlue)
                        .padding(.leading)
                        .frame(maxHeight: .infinity, alignment: .center)
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color(uiColor: .tertiarySystemBackground))
                        .aspectRatio(1.0, contentMode: .fill)
                        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 8)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        TodayContentView()
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
            .background(.appBg)
    }
    .environmentObject(Router())
}
