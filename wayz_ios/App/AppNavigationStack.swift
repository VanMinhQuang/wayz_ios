import SwiftUI

struct AppNavigationStack: View {
    @Bindable var router: AppRouter
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        NavigationStack(path: $router.path) {
            MainTabView()
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    )
                )
                .navigationDestination(for: AppRoute.self, destination: destination(for:))
        }
        .sheet(item: $router.presentedSheet, content: sheetContent(for:))
        .fullScreenCover(item: $router.presentedFullScreenCover, content: coverContent(for:))
        .environment(router)
        .theme(.default)
        .task {
            if !hasSeenOnboarding {
                router.present(.onboarding)
            }
        }
    }

    // MARK: - Stack destinations
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
            LoginView(viewModel: DIContainer.shared.resolve(LoginViewModel.self))
        case .userChat(let chatId):
            ChatView(
                viewModel: DIContainer.shared.resolve(ChatViewModel.self, argument: chatId)
            )
        case .userStory(let userId):
            UserStoryView(viewModel: DIContainer.shared.resolve(UserStoryViewModel.self, argument: userId))
        }
    }

    // MARK: - Sheets
    @ViewBuilder
    private func sheetContent(for sheet: AppSheet) -> some View {
        switch sheet {
        case .login:
            LoginView(viewModel: DIContainer.shared.resolve(LoginViewModel.self))
        case .editProfile(let userId):
            ProfileView(
                viewModel: DIContainer.shared.resolve(ProfileViewModel.self),
                userId: userId
            )
        }
    }

    // MARK: - Full screen covers
    @ViewBuilder
    private func coverContent(for cover: AppFullScreenCover) -> some View {
        switch cover {
        case .onboarding:
            OnboardingView()
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
