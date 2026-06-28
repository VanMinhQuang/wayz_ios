//
//  HomeView.swift
//  wayz_ios
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Loading...")
            } else if let user = viewModel.user {
                content(user: user)
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUser(id: "me") }
                }
            }
        }
        .task { await viewModel.loadUser(id: "me") }
    }

    // MARK: - Main content

    @ViewBuilder
    private func content(user: User) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: User card
                AppCard {
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(theme.colors.primary)

                        VStack(spacing: 4) {
                            Text("Welcome back,")
                                .font(theme.fonts.caption)
                                .foregroundStyle(theme.colors.textSecondary)
                            Text(user.name)
                                .font(theme.fonts.heading2)
                                .foregroundStyle(theme.colors.textPrimary)
                            Text(user.email)
                                .font(theme.fonts.caption)
                                .foregroundStyle(theme.colors.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: Quick actions
          

                // MARK: Logout
                AppButton(
                    title: "Log Out",
                    style: .destructive,
                    leadingIcon: "arrow.right.square"
                ) {
                    router.logOut()
                }
            }
            .padding(16)
        }
        .background(theme.colors.background.ignoresSafeArea())
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}
