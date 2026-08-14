//
//  HomeView.swift
//  wayz_ios
//

import SkeletonUI
import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    /// Stands in for `user` while `viewModel.isLoading`, so `content(user:)`
    /// itself can be skeletonized instead of duplicating its layout.
    private static let placeholderUser = User(id: "placeholder", name: "Wayz User", email: "user@example.com")

    init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUser(id: "me") }
                }
            } else {
                content(user: viewModel.user ?? Self.placeholderUser)
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
                            .skeleton(active: viewModel.isLoading)
                            .clipShape(Circle())

                        VStack(spacing: 4) {
                            Text("Welcome back,")
                                .font(theme.fonts.caption)
                                .foregroundStyle(theme.colors.textSecondary)
                                .skeleton(active: viewModel.isLoading)
                            Text(user.name)
                                .font(theme.fonts.heading2)
                                .foregroundStyle(theme.colors.textPrimary)
                                .skeleton(active: viewModel.isLoading)
                            Text(user.email)
                                .font(theme.fonts.caption)
                                .foregroundStyle(theme.colors.textSecondary)
                                .skeleton(active: viewModel.isLoading)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: Logout
                AppButton(
                    title: "Log Out",
                    style: .destructive,
                    leadingIcon: "arrow.right.square"
                ) {
                }
                .disabled(viewModel.isLoading)
                .skeleton(active: viewModel.isLoading)
            }
            .padding(16)
        }
        .background(theme.colors.background.ignoresSafeArea())
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}
