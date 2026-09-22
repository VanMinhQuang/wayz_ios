//
//  LoginViewModel.swift
//  wayz_ios
//

import Foundation
import Observation

@Observable
final class LoginViewModel {
    // MARK: - State
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var emailError: String?
    var passwordError: String?

    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
    private let session: AppSession

    init(userRepository: UserRepositoryProtocol, session: AppSession) {
        self.userRepository = userRepository
        self.session = session
    }

    // MARK: - Intents

    @MainActor
    func login() async {
        emailError = nil
        passwordError = nil
        var hasError = false
        if email.isEmpty {
            emailError = "Email is required"
            hasError = true
        }
        if password.isEmpty {
            passwordError = "Password is required"
            hasError = true
        }
        guard !hasError else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            // 1. Exchange credentials for tokens (stored in Keychain by the repo).
            _ = try await userRepository.login(email: email, password: password)
            // 2. Fetch the authenticated user's profile.
            let user = try await userRepository.fetchUser(id: "me")
      
            session.signIn(as: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func loginGoogle() async {
        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await userRepository.loginWithGoogle()
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
