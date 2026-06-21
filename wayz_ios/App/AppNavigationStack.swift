//
//  AppNavigationStack.swift
//  wayz_ios
//

import SwiftUI

struct AppNavigationStack: View {
    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(viewModel: DIContainer.shared.resolve(HomeViewModel.self))
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
        .theme(.default)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: DIContainer.shared.resolve(HomeViewModel.self))
        case .profile(let userId):
            ProfileView(
                viewModel: DIContainer.shared.resolve(ProfileViewModel.self),
                userId: userId
            )
        case .settings:
            SettingsPlaceholderView()
        case .login:
            LoginView(
                viewModel: DIContainer.shared.resolve(LoginViewModel.self),
                router: router
            )
        }
    }
}

// MARK: - Placeholder (replace with real SettingsView)
private struct SettingsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView("Settings", systemImage: "gearshape")
            .navigationTitle("Settings")
    }
}
