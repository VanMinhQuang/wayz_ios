//
//  ProfileView.swift
//  wayz_ios
//

import SkeletonUI
import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @Environment(\.appTheme) private var theme
    let userId: String

    /// Stands in for `user` while `viewModel.isLoading`, so `content(user:)`
    /// itself can be skeletonized instead of duplicating its layout.
    private static let placeholderUser = User(id: "placeholder", name: "Wayz User", email: "user@example.com")

    init(viewModel: ProfileViewModel, userId: String) {
        self._viewModel = State(initialValue: viewModel)
        self.userId = userId
    }

    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUser(id: userId) }
                }
            } else {
                content(user: viewModel.user ?? Self.placeholderUser)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadUser(id: userId) }
    }

    // MARK: - Main content

    @ViewBuilder
    private func content(user: User) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: Avatar + name
                AppCard {
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 72))
                            .foregroundStyle(theme.colors.primary)
                            .skeleton(active: viewModel.isLoading)
                            .clipShape(Circle())

                        VStack(spacing: 4) {
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

                // MARK: Info rows
                AppCard(padding: 0) {
                    VStack(spacing: 0) {
                        AppCardRow(
                            icon: "envelope.fill",
                            iconColor: .blue,
                            title: "Email",
                            subtitle: user.email
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .skeleton(active: viewModel.isLoading)

                        Divider().padding(.leading, 64)

                        AppCardRow(
                            icon: "person.badge.key.fill",
                            iconColor: .orange,
                            title: "User ID",
                            subtitle: user.id
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .skeleton(active: viewModel.isLoading)
                    }
                }

                // MARK: Edit profile (placeholder)
                AppButton(
                    title: "Edit Profile",
                    style: .secondary,
                    leadingIcon: "pencil"
                ) {
                    // TODO: navigate to edit profile screen
                }
                .disabled(viewModel.isLoading)
                .skeleton(active: viewModel.isLoading)
            }
            .padding(16)
        }
        .background(theme.colors.background.ignoresSafeArea())
    }
}
