//
//  AppCard.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Component

struct AppCard<Content: View>: View {
    @Environment(\.appTheme) private var theme

    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16
    var hasShadow: Bool = true
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: hasShadow ? .black.opacity(0.06) : .clear,
                radius: 8,
                x: 0,
                y: 2
            )
    }
}

// MARK: - Row Variant (icon + title + subtitle + optional trailing)

struct AppCardRow: View {
    @Environment(\.appTheme) private var theme

    let icon: String
    var iconColor: Color? = nil
    let title: String
    var subtitle: String? = nil
    var trailingText: String? = nil
    var showChevron: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(iconColor ?? theme.colors.primary)
                .frame(width: 36, height: 36)
                .background((iconColor ?? theme.colors.primary).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.fonts.body)
                    .foregroundStyle(theme.colors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(theme.fonts.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }

            Spacer()

            if let trailing = trailingText {
                Text(trailing)
                    .font(theme.fonts.caption)
                    .foregroundStyle(theme.colors.textSecondary)
            }

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(theme.colors.textSecondary.opacity(0.5))
            }
        }
    }
}
