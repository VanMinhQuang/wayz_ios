//
//  AppTheme.swift
//  wayz_ios
//

import SwiftUI

/// Defines the visual theme configuration for the application.
struct AppTheme {
    let colors: Colors
    let fonts: Fonts
    let gradients: Gradients
 
    struct Colors {
        // Brand
        let primary: Color
        let secondary: Color
        let accent: Color
 
        // Surfaces
        let background: Color
        let surface: Color
        let surfaceElevated: Color
 
        // Text
        let textPrimary: Color
        let textSecondary: Color
        let textDisabled: Color
        let onPrimary: Color      // chữ/icon đặt trên nền `primary`
        let onSecondary: Color    // chữ/icon đặt trên nền `secondary`
 
        // Border & Divider
        let border: Color
        let divider: Color
 
        // Trạng thái (status)
        let success: Color
        let warning: Color
        let error: Color
        let info: Color
    }
 
    struct Fonts {
        let heading1: Font
        let heading2: Font
        let body: Font
        let caption: Font
    }
    struct Gradients {
          let primary: LinearGradient
          let secondary: LinearGradient
      }
}

// MARK: - Default Theme
extension AppTheme {
    static let `default` = AppTheme(
        colors: Colors(
            // Brand
            primary: .blue,
            secondary: .teal,
            accent: .orange,
 
            // Surfaces
            background: Color(UIColor.systemBackground),
            surface: Color(UIColor.secondarySystemBackground),
            surfaceElevated: Color(UIColor.tertiarySystemBackground),
 
            // Text
            textPrimary: .primary,
            textSecondary: .secondary,
            textDisabled: Color(UIColor.tertiaryLabel),
            onPrimary: .white,
            onSecondary: .white,
 
            // Border & Divider
            border: Color(UIColor.separator),
            divider: Color(UIColor.opaqueSeparator),
 
            // Trạng thái
            success: .green,
            warning: .yellow,
            error: .red,
            info: .blue
        ),
        fonts: Fonts(
            heading1: .system(size: 28, weight: .bold, design: .default),
            heading2: .system(size: 22, weight: .semibold, design: .default),
            body: .system(size: 16, weight: .regular, design: .default),
            caption: .system(size: 12, weight: .medium, design: .default)
        ),
        gradients: Gradients(
               primary: LinearGradient(
                   colors: [Color(red: 0.16, green: 0.50, blue: 0.98), Color(red: 0.45, green: 0.24, blue: 0.93)],
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing
               ),
               secondary: LinearGradient(
                   colors: [.teal, .green],
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing
               )
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
