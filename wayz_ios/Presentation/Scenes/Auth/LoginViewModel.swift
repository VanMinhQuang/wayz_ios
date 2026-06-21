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

    // MARK: - Dependencies
    private let loginUseCase: LoginUseCase
    var onLoginSuccess: (() -> Void)?

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    // MARK: - Intents

    @MainActor
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await loginUseCase.execute(email: email, password: password)
            onLoginSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
