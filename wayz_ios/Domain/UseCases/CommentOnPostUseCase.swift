//
//  CommentOnPostUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

/// Delivered server-side as a direct message to the post owner (doc §7.5).
final class CommentOnPostUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: String, body: String, postRefId: String? = nil) async throws -> Message {
        try await repository.commentOnPost(postId: postId, body: body, postRefId: postRefId)
    }
}
