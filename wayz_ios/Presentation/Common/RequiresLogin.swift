//
//  RequiresLogin.swift
//  wayz_ios
//
//  Reusable login gate. Any view can protect itself with:
//
//      MyView().requiresLogin()
//
//  When `AppSession.currentUser` is nil the wrapped view is replaced
//  by a full-screen prompt with an "Đăng nhập" button that pushes
//  `AppRoute.login`. Once the user signs in (`session.signIn(as:)`),
//  the wrapped content re-appears automatically.
//
//  Requires `AppSession` and `AppRouter` to be present in the environment.
//

import SwiftUI

/// Standalone prompt view — usually shown by the `requiresLogin()` modifier,
/// but exposed for cases where a screen wants to embed it manually.
struct LoginPromptView: View {
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    var title: String = "Chưa đăng nhập"
    var message: String = "Vui lòng đăng nhập để tiếp tục sử dụng tính năng này."
    var actionTitle: String = "Đăng nhập"

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 72))
                .foregroundStyle(theme.colors.textSecondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(theme.fonts.heading2)
                    .foregroundStyle(theme.colors.textPrimary)
                Text(message)
                    .font(theme.fonts.body)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            AppButton(title: actionTitle) {
                router.push(.login)
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background.ignoresSafeArea())
    }
}

private struct RequiresLoginModifier: ViewModifier {
    @Environment(AppSession.self) private var session
    let title: String
    let message: String

    func body(content: Content) -> some View {
        if session.isSignedIn {
            content
        } else {
            LoginPromptView(title: title, message: message)
        }
    }
}

extension View {
    /// Show this view only when the user is signed in; otherwise substitute
    /// a login prompt. `title` / `message` let each screen phrase the reason
    /// (e.g. "Đăng nhập để nhắn tin", "Đăng nhập để xem hồ sơ", …).
    func requiresLogin(
        title: String = "Chưa đăng nhập",
        message: String = "Vui lòng đăng nhập để tiếp tục sử dụng tính năng này."
    ) -> some View {
        modifier(RequiresLoginModifier(title: title, message: message))
    }
}
