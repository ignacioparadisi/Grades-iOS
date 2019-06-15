//
//  Theme.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

let themeKey = "SelectedTheme"

enum FontWeight {
    case light
    case regular
    case medium
    case bold
}

enum Theme: Int {
    case dark
    
    func font(style: FontStyle, size: CGFloat) -> UIFont {
        let fontName = "HelveticaNeue"
        return UIFont(name: fontName, style: style, size: size)
    }
    
    var titleFont: UIFont {
        return font(style: .bold, size: 30.0)
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .dark:
            return .black
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark:
            return .lightContent
        }
    }
    
    // Colors
    
    var accentColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0xff9500)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            // return UIColor(hex: 0x393939)
            return .black
        }
    }
    
    var cardBackgroundColor: UIColor {
        switch self {
        case .dark:
            // return UIColor(hex: 0x2D2D2D)
            return UIColor(hex: 0x1C1C1E)
        }
    }
    
    var tabBarBackgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0x1B1B1B)
        }
    }
    
    var tableViewBackgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0x181818)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0xFFFFFF)
        }
    }
    
    var lightTextColor: UIColor {
        switch self {
        case .dark:
            return .white
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0xABADAD)
        }
    }
    
    var highlightTableViewCellColor: UIColor {
        switch self {
        case .dark:
            return UIColor(hex: 0x333333)
        }
    }
    
    var disabledButtonBackgroundColor: UIColor {
        switch self {
        default:
            return UIColor(white: 0.4, alpha: 1)
        }
    }
    
    var disabledButtonTextColor: UIColor {
        switch self {
        default:
            return .lightGray
        }
    }
    
    var greenColor: UIColor {
        return UIColor(hex: 0x1AB23D)
    }
    
    var redColor: UIColor {
        return UIColor(hex: 0xB41111)
    }
    
    var yellowColor: UIColor {
        return UIColor(hex: 0xD8B627)
    }
}

/// Manages the theme changing and gets the current theme
struct ThemeManager {
    
    /// Defines which theme to use
    ///
    /// - Returns: Current selected theme
    static var currentTheme: Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: themeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }
    
    /// Adds a transition when changing the theme
    ///
    /// - Parameter theme: Selected theme
    static func applayTheme(_ theme: Theme) {
        if let window = UIApplication.shared.delegate?.window, let unwrappedWindow = window {
            UIView.transition(
                with: unwrappedWindow,
                duration: 0.2,
                options: [.transitionCrossDissolve],
                animations: {
                    self.apply(theme)
            },
                completion: nil
            )
        }
    }
    
    /// Sets the current theme in UserDefaults and makes the changes to the global views
    ///
    /// - Parameter theme: Selected theme
    private static func apply(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: themeKey)
        UserDefaults.standard.synchronize()
        
        setupNavigationBarAppearance(theme)
        setupTabBarAppearance(theme)
        setupLabelAppearance(theme)
        setupTableViewAppearance(theme)
        setupTableViewCellAppearance(theme)
        UIApplication.shared.delegate?.window??.tintColor = theme.accentColor
    }
    
    /// Applies changes to all UINavigationBars
    ///
    /// - Parameter theme: Selected theme
    private static func setupNavigationBarAppearance(_ theme: Theme) {
        UINavigationBar.appearance().barStyle = theme.barStyle
    }
    
    /// Applies changes to all UITabBars
    ///
    /// - Parameter theme: Selected theme
    private static func setupTabBarAppearance(_ theme: Theme) {
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().tintColor = theme.accentColor
    }
    
    /// Applies changes to all UILabels
    ///
    /// - Parameter theme: Selected theme
    private static func setupLabelAppearance(_ theme: Theme) {
        UILabel.appearance().textColor = theme.textColor
    }
    
    /// Applies changes to all UITableViews
    ///
    /// - Parameter theme: Selected theme
    private static func setupTableViewAppearance(_ theme: Theme) {
        UITableView.appearance().backgroundColor = theme.tableViewBackgroundColor
    }
    
    /// Applies changes to all UITableCells
    ///
    /// - Parameter theme: Selected theme
    private static func setupTableViewCellAppearance(_ theme: Theme) {
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
    }
    
}
