//
//  RegisterView.swift
//  wayz_ios
//

import SwiftUI

struct RegisterView: View {
    @State private var viewModel: RegisterViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router
    @Environment(AppSession.self) private var session

    init(viewModel: RegisterViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 48))
                            .foregroundStyle(theme.colors.primary)

                        Text("Tạo tài khoản")
                            .font(theme.fonts.heading1)
                            .foregroundStyle(theme.colors.textPrimary)

                        Text("Gia nhập cộng đồng Wayz")
                            .font(theme.fonts.body)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    .padding(.top, 32)

                    // MARK: Fields
                    VStack(spacing: 16) {
                        AppTextField(
                            label: "Họ và tên",
                            placeholder: "Nguyễn Văn A",
                            text: $viewModel.fullName,
                            errorMessage: viewModel.fullNameError,
                            leadingIcon: "person",
                            autocapitalization: .words,
                            submitLabel: .next
                        )

                        AppTextField(
                            label: "Username",
                            placeholder: "yourname",
                            text: $viewModel.username,
                            errorMessage: viewModel.usernameError,
                            leadingIcon: "at",
                            autocapitalization: .never,
                            submitLabel: .next
                        )

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
                            label: "Mật khẩu",
                            placeholder: "Ít nhất 8 ký tự",
                            text: $viewModel.password,
                            errorMessage: viewModel.passwordError,
                            submitLabel: .go,
                            onSubmit: { Task { await viewModel.register() } }
                        )
                    }

                    // MARK: Error banner
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(theme.fonts.caption)
                            .foregroundStyle(theme.colors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // MARK: Actions
                    AppButton(
                        title: "Đăng ký",
                        style: .primary,
                        isLoading: viewModel.isLoading,
                        leadingIcon: "arrow.right"
                    ) {
                        Task { await viewModel.register() }
                    }

                    // MARK: Switch to login
                    HStack(spacing: 4) {
                        Text("Đã có tài khoản?")
                            .font(theme.fonts.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                        Button("Đăng nhập") {
                            router.pop()
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

            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .background(theme.colors.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        // Once the VM writes the freshly-registered user to the session, pop
        // back to whatever screen requested login (or the login screen itself
        // if arriving from there).
        .onChange(of: session.isSignedIn) { _, isSignedIn in
            if isSignedIn {
                router.popToRoot()
            }
        }
    }

    // MARK: - Loading overlay

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(theme.colors.primary)
                    .scaleEffect(1.4)
                Text("Đang tạo tài khoản…")
                    .font(theme.fonts.caption)
                    .foregroundStyle(theme.colors.textPrimary)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface)
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
            )
        }
        .transition(.opacity)
    }
}
