//
//  UnlikePostUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class UnlikePostUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: String) async throws {
        try await repository.unlikePost(postId: postId)
    }
}
