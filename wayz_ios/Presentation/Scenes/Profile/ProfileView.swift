//
//  ProfileView.swift
//  wayz_ios
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @Environment(\.appTheme) private var theme
    let userId: String

    init(viewModel: ProfileViewModel, userId: String) {
        self._viewModel = State(initialValue: viewModel)
        self.userId = userId
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Loading profile...")
            } else if let user = viewModel.user {
                content(user: user)
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUser(id: userId) }
                }
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

                        VStack(spacing: 4) {
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

                        Divider().padding(.leading, 64)

                        AppCardRow(
                            icon: "person.badge.key.fill",
                            iconColor: .orange,
                            title: "User ID",
                            subtitle: user.id
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
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
            }
            .padding(16)
        }
        .background(theme.colors.background.ignoresSafeArea())
    }
}
