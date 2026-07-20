//
//  AppImage.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Content mode

enum AppImageContentMode {
    case fill
    case fit
}

// MARK: - Component

/// A themed, reusable async image with a consistent placeholder/failure state,
/// rounded corners and an optional border — use this instead of raw `AsyncImage`.
struct AppImage: View {
    @Environment(\.appTheme) private var theme

    let url: URL?
    var contentMode: AppImageContentMode = .fill
    var cornerRadius: CGFloat = 16
    var showsBorder: Bool = false
    /// Fixed width. When `nil` (the default), AppImage expands to fill whatever
    /// width its parent/caller gives it — same for `height` below.
    var width: CGFloat? = nil
    /// Fixed height. When `nil` (the default), AppImage expands to fill
    /// whatever height its parent/caller gives it.
    var height: CGFloat? = nil

    init(
        url: URL?,
        contentMode: AppImageContentMode = .fill,
        cornerRadius: CGFloat = 16,
        showsBorder: Bool = false,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.url = url
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.showsBorder = showsBorder
        self.width = width
        self.height = height
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode == .fill ? .fill : .fit)
                    // Force the image to actually claim all space given to AppImage —
                    // without this, the resizable image can size itself to its own
                    // ideal size and never expand/crop to fill the parent frame.
                    .frame(sizing: (width, height))
            case .failure:
                placeholder(icon: "photo.badge.exclamationmark")
            case .empty:
                placeholder(icon: "photo", isLoading: true)
            @unknown default:
                placeholder(icon: "photo")
            }
        }
        // Guarantee AppImage always fills whatever frame its caller gives it
        // (or the explicit width/height, if provided), regardless of the
        // phase currently being rendered.
        .frame(sizing: (width, height))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(showsBorder ? Color(UIColor.separator) : .clear, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func placeholder(icon: String, isLoading: Bool = false) -> some View {
        ZStack {
            theme.colors.surface
            if isLoading {
                ProgressView()
                    .tint(theme.colors.textSecondary)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(theme.colors.textSecondary)
            }
        }
        .frame(sizing: (width, height))
    }
}

private extension View {
    /// Applies a fixed size for whichever dimensions are non-nil, and expands
    /// to fill the remaining dimensions — e.g. `(width: 100, height: nil)`
    /// pins the width to 100 while still filling all available height.
    @ViewBuilder
    func frame(sizing: (width: CGFloat?, height: CGFloat?)) -> some View {
        self
            .frame(width: sizing.width, height: sizing.height)
            .frame(
                maxWidth: sizing.width == nil ? .infinity : nil,
                maxHeight: sizing.height == nil ? .infinity : nil
            )
    }
}

// MARK: - Previews

#Preview("AppImage") {
    VStack(spacing: 16) {
        // Fills whatever frame the parent gives it (existing behavior).
        AppImage(
            url: URL(string: "https://images.unsplash.com/photo-1626808642875-0aa545482dfb?w=800&q=80&auto=format&fit=crop"),
            cornerRadius: 24
        )
        .frame(height: 220)

        // Fixed width & height via the new init options — no external .frame needed.
        AppImage(
            url: URL(string: "https://images.unsplash.com/photo-1526779259212-939e64788e3c?w=800&q=80&auto=format&fit=crop"),
            cornerRadius: 24,
            width: 120,
            height: 120
        )

        AppImage(url: nil, cornerRadius: 24, showsBorder: true, height: 120)
    }
    .padding()
    .theme(.default)
}
