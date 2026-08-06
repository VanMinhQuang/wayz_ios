//
//  FollowUserUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class FollowUserUseCase {
    private let repository: SocialRepositoryProtocol

    init(repository: SocialRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws {
        try await repository.follow(userId: userId)
    }
}
