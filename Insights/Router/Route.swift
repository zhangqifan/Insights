//
//  Route.swift
//  Insights
//
//  Created by Shuhari on 2025-11-04.
//

import Foundation

/// Defines all available navigation destinations in the app
public enum Route: Equatable, Hashable {
    /// No route - represents an empty navigation state
    case none
    
    /// Daily routine view showing habit tracking
    case dailyRoutine
}
