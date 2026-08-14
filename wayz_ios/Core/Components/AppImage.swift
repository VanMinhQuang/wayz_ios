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

// MARK: - Nguồn ảnh

enum AppImageSource {
    case url(URL?)      // ảnh từ mạng, ví dụ avatar, ảnh bài đăng
    case asset(String)  // ảnh trong Assets.xcassets, ví dụ banner tĩnh
    case symbol(String) // SF Symbol, dùng khi muốn 1 icon cố định thay vì ảnh thật
}

// MARK: - Placeholder

enum AppImagePlaceholder {
    case icon(String)      // SF Symbol làm placeholder, mặc định "photo"
    case initials(String)  // chữ cái đầu, hợp cho avatar khi user chưa có ảnh
    case color(Color)      // chỉ 1 màu nền, không icon/chữ

    static let `default` = AppImagePlaceholder.icon("photo")
}

// MARK: - Component

/// A themed, reusable image with a consistent placeholder/failure state,
/// rounded corners and an optional border — use this instead of raw `AsyncImage`
/// or `Image`. Supports remote URLs, local Assets, and SF Symbols through a
/// single API.
struct AppImage: View {
    @Environment(\.appTheme) private var theme

    let source: AppImageSource
    var contentMode: AppImageContentMode = .fill
    var cornerRadius: CGFloat = 16
    var showsBorder: Bool = false
    var placeholder: AppImagePlaceholder = .default
    /// Fixed width. When `nil` (the default), AppImage expands to fill whatever
    /// width its parent/caller gives it — same for `height` below.
    var width: CGFloat? = nil
    /// Fixed height. When `nil` (the default), AppImage expands to fill
    /// whatever height its parent/caller gives it.
    var height: CGFloat? = nil

    init(
        source: AppImageSource,
        contentMode: AppImageContentMode = .fill,
        cornerRadius: CGFloat = 16,
        showsBorder: Bool = false,
        placeholder: AppImagePlaceholder = .default,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.source = source
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.showsBorder = showsBorder
        self.placeholder = placeholder
        self.width = width
        self.height = height
    }

    var body: some View {
        content
            .frame(sizing: (width, height))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(showsBorder ? Color(UIColor.separator) : .clear, lineWidth: 1)
            )
    }

    @ViewBuilder
    private var content: some View {
        switch source {
        case .url(let url):
            remoteImage(url)

        case .asset(let name):
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode == .fill ? .fill : .fit)
                    .frame(sizing: (width, height))
            } else {
                // Tên asset sai hoặc chưa được thêm vào Assets -> vẫn cần fallback
                placeholderView(isLoading: false)
            }

        case .symbol(let name):
            ZStack {
                theme.colors.surface
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(theme.colors.textSecondary)
                    .padding(width == nil && height == nil ? 14 : min(width ?? 40, height ?? 40) * 0.28)
            }
            .frame(sizing: (width, height))
        }
    }

    @ViewBuilder
    private func remoteImage(_ url: URL?) -> some View {
        if let url {
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
                    placeholderView(isLoading: false)
                case .empty:
                    placeholderView(isLoading: true)
                @unknown default:
                    placeholderView(isLoading: false)
                }
            }
        } else {
            // Không có URL -> chưa có ảnh, hiện placeholder ngay, khỏi gọi mạng
            placeholderView(isLoading: false)
        }
    }

    @ViewBuilder
    private func placeholderView(isLoading: Bool) -> some View {
        ZStack {
            theme.colors.surface

            if isLoading {
                ProgressView()
                    .tint(theme.colors.textSecondary)
            } else {
                switch placeholder {
                case .icon(let symbolName):
                    Image(systemName: symbolName)
                        .font(.system(size: 22))
                        .foregroundStyle(theme.colors.textSecondary)
                case .initials(let name):
                    Text(initials(from: name))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(theme.colors.primary)
                case .color(let color):
                    color
                }
            }
        }
        .frame(sizing: (width, height))
    }

    private func initials(from name: String) -> String {
        let letters = name.split(separator: " ").prefix(2).compactMap { $0.first }
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }
}

// MARK: - Convenience initializers

extension AppImage {
    /// Dùng nhanh cho avatar user: tự fallback theo initials nếu không có ảnh
    /// hoặc load lỗi.
    static func avatar(
        url: URL?,
        name: String,
        cornerRadius: CGFloat = 999,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) -> AppImage {
        AppImage(
            source: .url(url),
            cornerRadius: cornerRadius,
            placeholder: .initials(name),
            width: width,
            height: height
        )
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
        // URL hợp lệ, fill khung parent
        AppImage(
            source: .url(URL(string: "https://images.unsplash.com/photo-1626808642875-0aa545482dfb?w=800&q=80&auto=format&fit=crop")),
            cornerRadius: 24
        )
        .frame(height: 220)

        HStack(spacing: 16) {
            // Avatar có ảnh
            AppImage.avatar(
                url: URL(string: "https://i.pravatar.cc/150?img=8"),
                name: "Minh Anh",
                width: 56,
                height: 56
            )

            // Avatar không có URL -> fallback initials
            AppImage.avatar(url: nil, name: "Quốc Bảo", width: 56, height: 56)

            // URL sai/hỏng -> fallback icon mặc định
            AppImage(
                source: .url(URL(string: "https://khong-ton-tai.example/x.png")),
                cornerRadius: 999,
                width: 56,
                height: 56
            )
        }

        // Ảnh từ Assets.xcassets
        AppImage(
            source: .asset("onboarding_banner"),
            cornerRadius: 24,
            placeholder: .color(.gray.opacity(0.2)),
            height: 120
        )

        // SF Symbol dùng như icon đồng nhất qua AppImage
        AppImage(source: .symbol("bell.fill"), cornerRadius: 999, width: 40, height: 40)
    }
    .padding()
    .theme(.default)
}
