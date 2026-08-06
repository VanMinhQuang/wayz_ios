//
//  DeletePostUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class DeletePostUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: String) async throws {
        try await repository.deletePost(postId: postId)
    }
}
