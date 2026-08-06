//
//  GetUserPostsUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetUserPostsUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String, limit: Int = 30) async throws -> [Post] {
        try await repository.fetchPosts(userId: userId, limit: limit)
    }
}
