//
//  LoginView.swift
//  wayz_ios
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    init(viewModel: LoginViewModel) {
        self._viewModel = State(initialValue: viewModel)
   
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // MARK: Header
                VStack(spacing: 8) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(theme.colors.primary)

                    Text("Welcome Back")
                        .font(theme.fonts.heading1)
                        .foregroundStyle(theme.colors.textPrimary)

                    Text("Sign in to continue")
                        .font(theme.fonts.body)
                        .foregroundStyle(theme.colors.textSecondary)
                }
                .padding(.top, 48)

                // MARK: Fields
                VStack(spacing: 16) {
                    AppTextField(
                        label: "Email",
                        placeholder: "you@example.com",
                        text: $viewModel.email,
                        errorMessage: viewModel.emailError,
                        leadingIcon: "envelope",
                        keyboardType: .emailAddress,
                        autocapitalization: .never,
                        submitLabel: .next
                    )

                    AppSecureField(
                        label: "Password",
                        placeholder: "Enter your password",
                        text: $viewModel.password,
                        errorMessage: viewModel.passwordError,
                        submitLabel: .go,
                        onSubmit: { Task { await viewModel.login() } }
                    )
                }

                // MARK: Error banner
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Text(error)
                            .font(theme.fonts.caption)
                            .foregroundStyle(theme.colors.error)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }

                // MARK: Actions
                VStack(spacing: 12) {
                    AppButton(
                        title: "Log In",
                        style: .primary,
                        isLoading: viewModel.isLoading,
                        leadingIcon: "arrow.right"
                    ) {
                        Task { await viewModel.login() }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(theme.colors.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
    }
}
