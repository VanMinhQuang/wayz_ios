//
//  HomeViewModel.swift
//  wayz_ios
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
    // MARK: - State
    var user: User?
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Dependencies
    private let getUserUseCase: GetUserUseCase

    init(getUserUseCase: GetUserUseCase) {
        self.getUserUseCase = getUserUseCase
    }

    // MARK: - Intents

    @MainActor
    func loadUser(id: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await getUserUseCase.execute(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
