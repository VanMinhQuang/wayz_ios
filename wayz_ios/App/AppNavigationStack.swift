//
//  AppNavigationStack.swift
//  wayz_ios
//

import SwiftUI

struct AppNavigationStack: View {
    @Bindable var router: AppRouter

    var body: some View {
        ZStack {
            MainTabView()
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal:   .move(edge: .leading).combined(with: .opacity)
                )
            )
            
        }
        .environment(router)
        .theme(.default)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
   
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
