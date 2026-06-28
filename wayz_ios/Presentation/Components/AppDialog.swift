//
//  AppDialog.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Model

struct AppDialogAction {
    let title: String
    let style: AppButtonStyle
    let action: () -> Void

    static func primary(_ title: String, action: @escaping () -> Void) -> AppDialogAction {
        AppDialogAction(title: title, style: .primary, action: action)
    }

    static func secondary(_ title: String, action: @escaping () -> Void) -> AppDialogAction {
        AppDialogAction(title: title, style: .secondary, action: action)
    }

    static func destructive(_ title: String, action: @escaping () -> Void) -> AppDialogAction {
        AppDialogAction(title: title, style: .destructive, action: action)
    }

    static func ghost(_ title: String, action: @escaping () -> Void) -> AppDialogAction {
        AppDialogAction(title: title, style: .ghost, action: action)
    }
}

// MARK: - Component

struct AppDialog: View {
    @Environment(\.appTheme) private var theme

    let title: String
    let message: String
    var icon: String? = nil
    var iconColor: Color? = nil
    let actions: [AppDialogAction]

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                // Icon
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 40))
                        .foregroundStyle(iconColor ?? theme.colors.primary)
                }

                // Title + message
                VStack(spacing: 8) {
                    Text(title)
                        .font(theme.fonts.heading2)
                        .foregroundStyle(theme.colors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(theme.fonts.body)
                        .foregroundStyle(theme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(24)

            Divider()

            // Actions
            if actions.count == 2 {
                HStack(spacing: 0) {
                    actionButton(actions[0])
                    Divider().frame(height: 50)
                    actionButton(actions[1])
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(actions.indices, id: \.self) { i in
                        if i > 0 { Divider() }
                        actionButton(actions[i])
                    }
                }
            }
        }
        .background(theme.colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 10)
        .padding(.horizontal, 32)
    }

    @ViewBuilder
    private func actionButton(_ dialogAction: AppDialogAction) -> some View {
        Button(action: dialogAction.action) {
            Text(dialogAction.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(buttonForeground(for: dialogAction.style))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
    }

    private func buttonForeground(for style: AppButtonStyle) -> Color {
        switch style {
        case .primary:     return theme.colors.primary
        case .secondary:   return theme.colors.primary
        case .destructive: return theme.colors.error
        case .ghost:       return theme.colors.textSecondary
        }
    }
}

// MARK: - View Modifier

struct AppDialogModifier: ViewModifier {
    @Environment(\.appTheme) private var theme
    @Binding var isPresented: Bool
    let dialog: AppDialog

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture { /* consume taps */ }

                dialog
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
}

extension View {
    /// Presents an `AppDialog` as a modal overlay.
    ///
    /// Usage:
    /// ```swift
    /// .appDialog(isPresented: $showDialog) {
    ///     AppDialog(
    ///         title: "Delete Account",
    ///         message: "This action cannot be undone.",
    ///         icon: "trash.fill",
    ///         iconColor: .red,
    ///         actions: [
    ///             .destructive("Delete") { /* … */ },
    ///             .ghost("Cancel") { showDialog = false }
    ///         ]
    ///     )
    /// }
    /// ```
    func appDialog(isPresented: Binding<Bool>, @ViewBuilder dialog: () -> AppDialog) -> some View {
        modifier(AppDialogModifier(isPresented: isPresented, dialog: dialog()))
    }
}

// MARK: - Previews

#Preview("Confirmation Dialog") {
    @Previewable @State var show = true

    Color(UIColor.systemGroupedBackground)
        .ignoresSafeArea()
        .appDialog(isPresented: $show) {
            AppDialog(
                title: "Delete Account",
                message: "This will permanently remove all your data and cannot be undone.",
                icon: "trash.fill",
                iconColor: .red,
                actions: [
                    .destructive("Delete") { show = false },
                    .ghost("Cancel") { show = false }
                ]
            )
        }
}

#Preview("Info Dialog") {
    @Previewable @State var show = true

    Color(UIColor.systemGroupedBackground)
        .ignoresSafeArea()
        .appDialog(isPresented: $show) {
            AppDialog(
                title: "Update Available",
                message: "Version 2.0 includes new maps and improved navigation.",
                icon: "arrow.down.circle.fill",
                iconColor: .blue,
                actions: [
                    .primary("Update Now") { show = false },
                    .ghost("Later") { show = false }
                ]
            )
        }
}
