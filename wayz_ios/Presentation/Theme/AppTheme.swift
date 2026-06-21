//
//  AppTheme.swift
//  wayz_ios
//

import SwiftUI

/// Defines the visual theme configuration for the application.
struct AppTheme {
    let colors: Colors
    let fonts: Fonts

    struct Colors {
        let primary: Color
        let secondary: Color
        let background: Color
        let surface: Color
        let textPrimary: Color
        let textSecondary: Color
        let error: Color
    }

    struct Fonts {
        let heading1: Font
        let heading2: Font
        let body: Font
        let caption: Font
    }
}

// MARK: - Default Theme
extension AppTheme {
    static let `default` = AppTheme(
        colors: Colors(
            primary: .blue,
            secondary: .teal,
            background: Color(UIColor.systemBackground),
            surface: Color(UIColor.secondarySystemBackground),
            textPrimary: .primary,
            textSecondary: .secondary,
            error: .red
        ),
        fonts: Fonts(
            heading1: .system(size: 28, weight: .bold, design: .default),
            heading2: .system(size: 22, weight: .semibold, design: .default),
            body: .system(size: 16, weight: .regular, design: .default),
            caption: .system(size: 12, weight: .medium, design: .default)
        )
    )
}

// MARK: - SwiftUI Environment Integration

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

extension View {
    /// Applies a specific theme to the view hierarchy.
    func theme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
