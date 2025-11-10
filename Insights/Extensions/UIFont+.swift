//
//  UIFont+.swift
//  Insights
//
//  Created by Shuhari on 2025-11-05 23:46.
//

import UIKit
import CoreText

extension UIFont {
    /// Creates a system font with rounded design
    /// - Parameters:
    ///   - size: The point size of the font
    ///   - weight: The weight of the font
    /// - Returns: A rounded system font with the specified size and weight, or a regular system font if rounded design is unavailable
    class func roundedFont(fontSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        if let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    /// Converts a UIFont to CTFont
    var ctFont: CTFont {
        return CTFontCreateCopyWithAttributes(self as CTFont, pointSize, nil, nil)
    }
}
