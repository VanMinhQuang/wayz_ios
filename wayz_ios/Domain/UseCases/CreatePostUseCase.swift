//
//  CreatePostUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class CreatePostUseCase {
    private let repository: PostsRepositoryProtocol

    init(repository: PostsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(imageURL: String, caption: String? = nil, placeId: String? = nil) async throws -> Post {
        try await repository.createPost(imageURL: imageURL, caption: caption, placeId: placeId)
    }
}
