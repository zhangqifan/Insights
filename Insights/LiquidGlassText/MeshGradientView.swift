//
//  MeshGradientView.swift
//  Insights
//
//  Created on November 6, 2025.
//

import SwiftUI

/// View demonstrating liquid glass text effect with mesh gradient background
struct MeshGradientView: View {
    /// Current text to display
    @State private var text: String = "Grow"
    
    /// Tint color for the glass effect
    @State private var tintColor: Color = .appBg.opacity(0.2)
    
    /// Offset for draggable text
    @State private var textOffset: CGSize = .zero
    
    /// Gradient color palette for the mesh
    private let gradientColors: [Color] = [
        Color(hex: "#58EFEC"),
        Color(hex: "#7CCAD5"),
        Color(hex: "#A0A6BE"),
        Color(hex: "#C481A7"),
        Color(hex: "#E85C90")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                // Mesh gradient background with liquid glass text overlay
                ZStack {
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            // Row 0
                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                            // Row 1
                            [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                            // Row 2
                            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                        ],
                        colors: [
                            // Row 0
                            gradientColors[0], gradientColors[1], gradientColors[2],
                            // Row 1
                            gradientColors[1], gradientColors[3], gradientColors[4],
                            // Row 2
                            gradientColors[2], gradientColors[4], gradientColors[3]
                        ]
                    )
                    .frame(height: geometry.size.height * 1/2)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    let font: UIFont = .roundedFont(fontSize: 48, weight: .bold)
                    
                    // Draggable liquid glass text
                    if !text.isEmpty {
                        Text(text)
                            .font(Font(font))
                            .foregroundStyle(.clear)
                            .glassEffect(.clear.tint(tintColor), in: GlyphShape(text: text, font: font.ctFont))
                            .compositingGroup()
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            .padding()
                            .offset(textOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        textOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            textOffset = .zero
                                        }
                                    }
                            )
                    }
                }
                
                // Hint text
                Text("Drag the text above to experience the Liquid Glass effect")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                
                // Text input and color picker
                HStack(spacing: 12) {
                    TextField("Enter text...", text: $text)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.growMain)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(uiColor: .tertiarySystemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(uiColor: .quaternaryLabel).opacity(0.3), lineWidth: 0.5)
                        )
                    
                    // Color picker
                    ColorPicker("", selection: $tintColor, supportsOpacity: true)
                        .labelsHidden()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(uiColor: .tertiarySystemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color(uiColor: .quaternaryLabel).opacity(0.3), lineWidth: 0.5)
                        )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    MeshGradientView()
}

