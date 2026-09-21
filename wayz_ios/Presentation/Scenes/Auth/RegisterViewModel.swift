//
//  RegisterViewModel.swift
//  wayz_ios
//

import Foundation
import Observation

@Observable
final class RegisterViewModel {
    // MARK: - State
    var email: String = ""
    var username: String = ""
    var password: String = ""
    var fullName: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var emailError: String?
    var usernameError: String?
    var passwordError: String?
    var fullNameError: String?

    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
    private let session: AppSession

    init(userRepository: UserRepositoryProtocol, session: AppSession) {
        self.userRepository = userRepository
        self.session = session
    }

    // MARK: - Intents

    @MainActor
    func register() async {
        emailError = nil
        usernameError = nil
        passwordError = nil
        fullNameError = nil
        errorMessage = nil

        var hasError = false
        if email.isEmpty {
            emailError = "Email is required"
            hasError = true
        }
        if username.isEmpty {
            usernameError = "Username is required"
            hasError = true
        }
        if password.isEmpty {
            passwordError = "Password is required"
            hasError = true
        } else if password.count < 8 {
            passwordError = "Password must be at least 8 characters"
            hasError = true
        }
        if fullName.isEmpty {
            fullNameError = "Full name is required"
            hasError = true
        }
        guard !hasError else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            // 1. Create account.
            _ = try await userRepository.register(
                email: email,
                username: username,
                password: password,
                fullName: fullName
            )
            // 2. Immediately log in to obtain tokens (register endpoint does
            // not return them per doc §1.1).
            _ = try await userRepository.login(email: email, password: password)
            // 3. Fetch full profile & publish into global session so any
            // gated screen re-renders with the user signed in.
            let user = try await userRepository.fetchUser(id: "me")
            session.signIn(as: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
