//
//  AppButton.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Style

enum AppButtonStyle {
    case primary
    case secondary
    case destructive
    case ghost
}

enum AppButtonSize {
    case large
    case medium
    case small

    var height: CGFloat {
        switch self {
        case .large:  return 52
        case .medium: return 44
        case .small:  return 36
        }
    }

    var font: Font {
        switch self {
        case .large:  return .system(size: 16, weight: .semibold)
        case .medium: return .system(size: 15, weight: .semibold)
        case .small:  return .system(size: 13, weight: .medium)
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .large:  return 24
        case .medium: return 20
        case .small:  return 14
        }
    }
}

// MARK: - Component

struct AppButton: View {
    @Environment(\.appTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    let title: String
    var style: AppButtonStyle = .primary
    var size: AppButtonSize = .large
    var isLoading: Bool = false
    var leadingIcon: String? = nil
    var isFullWidth: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: { if !isLoading { action() } }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                        .scaleEffect(0.85)
                } else if let icon = leadingIcon {
                    Image(systemName: icon)
                        .font(size.font)
                }
                Text(title)
                    .font(size.font)
            }
            .foregroundStyle(foregroundColor)
            .frame(height: size.height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, isFullWidth ? 0 : size.horizontalPadding)
            .background(backgroundView)
            .opacity(isEnabled && !isLoading ? 1 : 0.5)
        }
        .disabled(isLoading)
    }

    // MARK: Colors

    private var foregroundColor: Color {
        switch style {
        case .primary:     return .white
        case .secondary:   return theme.colors.primary
        case .destructive: return .white
        case .ghost:       return theme.colors.primary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.primary)
        case .secondary:
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.colors.primary, lineWidth: 1.5)
        case .destructive:
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.error)
        case .ghost:
            Color.clear
        }
    }
}

// MARK: - Previews

#Preview("All Styles") {
    VStack(spacing: 16) {
        AppButton(title: "Primary", style: .primary) {}
        AppButton(title: "Secondary", style: .secondary) {}
        AppButton(title: "Destructive", style: .destructive) {}
        AppButton(title: "Ghost", style: .ghost) {}
        AppButton(title: "Loading", style: .primary, isLoading: true) {}
        AppButton(title: "With Icon", style: .primary, leadingIcon: "arrow.right") {}
        AppButton(title: "Small", style: .secondary, size: .small, isFullWidth: false) {}
        AppButton(title: "Disabled", style: .primary) {}
            .disabled(true)
    }
    .padding()
}
