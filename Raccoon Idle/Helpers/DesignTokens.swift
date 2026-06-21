//
//  DesignTokens.swift
//  Raccoon Bakery
//
//  Created by Junie on 6/21/26.
//

import UIKit

/// Centralized design tokens for the Raccoon Idle game.
/// Use these tokens instead of hardcoded values to ensure consistency across the UI.
struct DesignTokens {
    struct Colors {
        static let background = UIColor.purple
        static let buttonPrimary = UIColor.systemGreen
        static let buttonDisabled = UIColor.systemGray
        static let buttonHighlight = UIColor.magenta
        static let text = UIColor.white
    }
    
    struct Fonts {
        static let medium = "SanFranciscoRounded-Medium"
        static let largeSize: CGFloat = 24.0
        static let defaultSize: CGFloat = 18.0
        static let minSize: CGFloat = 4.0
    }
    
    struct Spacing {
        static let padding: CGFloat = 8.0
        static let uiPadding: CGFloat = 10.0
    }
}
