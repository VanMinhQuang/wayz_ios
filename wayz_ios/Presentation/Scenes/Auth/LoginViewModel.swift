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
    var onLoginSuccess: (() -> Void)?

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
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
            _ = try await userRepository.login(email: email, password: password)
            onLoginSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
