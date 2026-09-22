//
//  LoginView.swift
//  wayz_ios
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router
    @Environment(AppSession.self) private var session

    init(viewModel: LoginViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
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

                    // MARK: Actions
                    VStack(spacing: 12) {
                        AppButton(
                            title: "Đăng nhập",
                            style: .primary,
                            isLoading: viewModel.isLoading,
                        ) {
                            Task { await viewModel.login() }
                        }

                        socialDivider

                        googleSignInButton
                    }

                    // MARK: Sign up prompt
                    HStack(spacing: 4) {
                        Text("Chưa có tài khoản?")
                            .font(theme.fonts.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                        Button("Đăng ký") {
                            router.push(.register)
                        }
                        .font(theme.fonts.caption)
                        .foregroundStyle(theme.colors.primary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .disabled(viewModel.isLoading)

            // MARK: Loading overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(theme.colors.primary)
                        .scaleEffect(1.4)
                    Text("Đang đăng nhập…")
                        .font(theme.fonts.caption)
                        .foregroundStyle(theme.colors.textPrimary)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(theme.colors.surface)
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                )
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .background(theme.colors.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        .alert("Đăng nhập thất bại", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            if let msg = viewModel.errorMessage {
                Text(msg)
            }
        }
        .onChange(of: session.isSignedIn) { _, isSignedIn in
            if isSignedIn {
                router.pop()
            }
        }
    }

    // MARK: - Social sign-in section

    private var socialDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(theme.colors.border)
                .frame(height: 1)
            Text("hoặc")
                .font(theme.fonts.caption)
                .foregroundStyle(theme.colors.textSecondary)
            Rectangle()
                .fill(theme.colors.border)
                .frame(height: 1)
        }
    }

    /// Google sign-in — UI stub. Wire this up when the backend adds an OAuth
    /// endpoint and the GoogleSignIn SDK is added to the project.
    private var googleSignInButton: some View {
        Button(action: signInWithGoogle) {
            HStack(spacing: 10) {
                Image(systemName: "g.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(red: 0.92, green: 0.26, blue: 0.21))
                Text("Đăng nhập với Google")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(theme.colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.colors.border, lineWidth: 1)
            )
        }
    }

    private func signInWithGoogle() {
        Task {
            await viewModel.loginGoogle()
        }
    }
}
