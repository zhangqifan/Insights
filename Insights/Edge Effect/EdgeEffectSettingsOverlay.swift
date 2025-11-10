//
//  EdgeEffectSettingsOverlay.swift
//  Insights
//
//  Created by Shuhari on 2025-11-08.
//

import SwiftUI

/// Settings overlay for toggling between real and fake header implementations
struct EdgeEffectSettingsOverlay: View {
    @Binding var useFakeHeader: Bool
    
    /// Controls the visibility animation of the overlay
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Use Fake Header")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle("", isOn: $useFakeHeader)
                .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(Color.growBlue)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(.snappy.delay(0.5)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBg.ignoresSafeArea()
        
        VStack {
            Spacer()
            EdgeEffectSettingsOverlay(useFakeHeader: .constant(false))
                .padding(.bottom, 20)
        }
    }
}

