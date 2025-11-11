# Grow Insights for iOS 26

### Overview
A UIKit-based technical demonstration project showcasing practical solutions for specific UI/UX implementation scenarios. Built from real-world experience with Grow, this demo demonstrates how to handle advanced interface challenges using primarily UIKit, enhanced with SwiftUI where appropriate.

### Key Demonstrations
- **Popover Menu with Morph Effect**: Using `popoverPresentationController` to implement custom menu content in UIKit, featuring a month/year wheel picker
- **UIBarButtonItem Sizing**: Handling dynamic content sizing with `UIHostingController` and Auto Layout priorities in navigation bars
- **Scroll Edge Effect Control**: Comparing real supplementary headers vs. independent views to control iOS 26 edge blur behaviors
- **Liquid Glass Text Shape**: Converting text to glyph paths with CoreText for custom glass material effects

### Project Structure
```
Insights/
├── Today/              # Weekly picker & date selection patterns
├── Insights/           # Custom calendar components (UIKit primary, SwiftUI reference)
├── LiquidGlassText/    # Advanced text rendering techniques
├── Edge Effect/        # iOS 26 scroll behavior demonstrations
├── Router/             # Centralized navigation system
└── Extensions/         # Reusable utilities
```
