//
//  GlyphShape.swift
//  Insights
//
//  Created by Shuhari on 2025-11-06 00:40.
//

import CoreText
import SwiftUI

/// A Shape that renders text as vector paths, enabling advanced text effects
public struct GlyphShape: Shape {
    /// The text to render
    let text: String
    
    /// The CoreText font to use
    let font: CTFont
    
    /// Text alignment within the shape
    let alignment: TextAlignment
    
    // MARK: - Initialization
    
    public init(text: String, font: CTFont, alignment: TextAlignment = .leading) {
        self.text = text
        self.font = font
        self.alignment = alignment
    }
    
    // MARK: - Shape Protocol
    
    /// Creates a path representing the text glyphs
    /// - Parameter rect: The bounding rectangle for the shape
    /// - Returns: A path containing all glyph outlines
    public func path(in rect: CGRect) -> Path {
        var combinedPath = Path()
        
        guard !text.isEmpty else { return Path() }
        
        let paragraphStyle = createParagraphStyle(for: alignment)
        
        // Use NSAttributedString to ensure proper Unicode handling
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as UIFont,
            NSAttributedString.Key(kCTParagraphStyleAttributeName as String): paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
        
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRangeMake(0, 0),
            nil,
            CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude),
            nil
        )
        
        let frameRect = CGRect(x: 0, y: 0, width: rect.width, height: max(rect.height, suggestedSize.height))
        let textPath = CGPath(rect: frameRect, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textPath, nil)
        
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        
        var lineOrigins = [CGPoint](repeating: .zero, count: lineCount)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        
        for i in 0..<lineCount {
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            let lineOrigin = lineOrigins[i]
            let glyphRuns = CTLineGetGlyphRuns(line)
            
            for j in 0..<CFArrayGetCount(glyphRuns) {
                let run = unsafeBitCast(CFArrayGetValueAtIndex(glyphRuns, j), to: CTRun.self)
                let glyphCount = CTRunGetGlyphCount(run)
                
                var glyphs = [CGGlyph](repeating: 0, count: glyphCount)
                var positions = [CGPoint](repeating: .zero, count: glyphCount)
                
                CTRunGetGlyphs(run, CFRangeMake(0, 0), &glyphs)
                CTRunGetPositions(run, CFRangeMake(0, 0), &positions)
                
                // Get the run's font to ensure correct font usage
                let runAttributes = CTRunGetAttributes(run) as NSDictionary
                let runFont = (runAttributes[kCTFontAttributeName] as! CTFont?) ?? font
                
                for k in 0..<glyphCount {
                    if let glyphPath = CTFontCreatePathForGlyph(runFont, glyphs[k], nil) {
                        var singleGlyphPath = Path(glyphPath)
                        
                        let totalX = lineOrigin.x + positions[k].x
                        let totalY = lineOrigin.y + positions[k].y
                        let offsetTransform = CGAffineTransform(translationX: totalX, y: totalY)
                        singleGlyphPath = singleGlyphPath.applying(offsetTransform)
                        
                        combinedPath.addPath(singleGlyphPath)
                    }
                }
            }
        }
        
        let verticalOffset = (rect.height - suggestedSize.height) / 2
        
        let flipTransform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -frameRect.height + verticalOffset)
        
        return combinedPath.applying(flipTransform)
    }
    
    // MARK: - Private Methods
    
    /// Creates a CoreText paragraph style for the specified alignment
    /// - Parameter alignment: The desired text alignment
    /// - Returns: A configured CTParagraphStyle
    private func createParagraphStyle(for alignment: TextAlignment) -> CTParagraphStyle {
        var textAlignment: CTTextAlignment
        
        switch alignment {
        case .leading:
            textAlignment = .left
        case .center:
            textAlignment = .center
        case .trailing:
            textAlignment = .right
        @unknown default:
            textAlignment = .left
        }
        
        var lineSpacing: CGFloat = 0
        var settings = [
            CTParagraphStyleSetting(
                spec: .alignment,
                valueSize: MemoryLayout<CTTextAlignment>.size,
                value: &textAlignment
            ),
            CTParagraphStyleSetting(
                spec: .lineSpacingAdjustment,
                valueSize: MemoryLayout<CGFloat>.size,
                value: &lineSpacing
            )
        ]
        
        return CTParagraphStyleCreate(&settings, settings.count)
    }
}
