//
//  UnfollowUserUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class UnfollowUserUseCase {
    private let repository: SocialRepositoryProtocol

    init(repository: SocialRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws {
        try await repository.unfollow(userId: userId)
    }
}
