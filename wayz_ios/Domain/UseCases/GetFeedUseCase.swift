//
//  GetFeedUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetFeedUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int = 20) async throws -> [Post] {
        try await repository.fetchFeed(limit: limit)
    }
}
