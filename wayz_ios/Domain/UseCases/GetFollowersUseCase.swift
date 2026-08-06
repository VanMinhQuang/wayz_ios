//
//  GetFollowersUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetFollowersUseCase {
    private let repository: SocialRepositoryProtocol

    init(repository: SocialRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws -> [User] {
        try await repository.fetchFollowers(userId: userId)
    }
}
