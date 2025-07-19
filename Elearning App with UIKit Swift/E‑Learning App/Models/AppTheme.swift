//
//  AppTheme.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gear"
        }
    }
    
    var color: UIColor {
        switch self {
        case .light: return .systemBlue
        case .dark: return .systemPurple
        case .system: return .systemGreen
        }
    }
}

class ThemeManager {
    static let shared = ThemeManager()
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedAppTheme"
    
    var currentTheme: AppTheme {
        get {
            if let themeString = userDefaults.string(forKey: themeKey),
               let theme = AppTheme(rawValue: themeString) {
                return theme
            }
            return .system
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: themeKey)
            applyTheme(newValue)
        }
    }
    
    private init() {}
    
    func applyTheme(_ theme: AppTheme) {
        switch theme {
        case .light:
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        case .dark:
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        case .system:
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
        
        // Post notification for theme change
        NotificationCenter.default.post(name: .themeDidChange, object: theme)
    }
    
    func applyCurrentTheme() {
        applyTheme(currentTheme)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

// MARK: - Theme Colors
extension UIColor {
    static var themePrimary: UIColor {
        return ThemeManager.shared.currentTheme.color
    }
    
    static var themeBackground: UIColor {
        return UIColor.systemBackground
    }
    
    static var themeSecondaryBackground: UIColor {
        return UIColor.systemGroupedBackground
    }
    
    static var themeLabel: UIColor {
        return UIColor.label
    }
    
    static var themeSecondaryLabel: UIColor {
        return UIColor.secondaryLabel
    }
} 