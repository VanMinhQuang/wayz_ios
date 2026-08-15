//
//  ProfileViewModel.swift
//  wayz_ios
//

import Combine
import Foundation
import Observation

@Observable
final class ProfileViewModel {
    // MARK: - State
    var user: User?
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    // MARK: - Intents

    @MainActor
    func loadUser(id: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            user = try await userRepository.fetchUser(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
