//
//  PostsRemoteDataSource.swift
//  wayz_ios
//

final class PostsRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func createPost(imageURL: String, caption: String?, placeId: String?) async throws -> PostDTO {
        try await client.request(.createPost(imageURL: imageURL, caption: caption, placeId: placeId))
    }

    func deletePost(postId: String) async throws {
        try await client.requestVoid(.deletePost(postId: postId))
    }

    func fetchFeed(limit: Int) async throws -> [PostDTO] {
        try await client.request(.getFeed(limit: limit))
    }

    func fetchPosts(userId: String, limit: Int) async throws -> [PostDTO] {
        try await client.request(.getPostsByUser(userId: userId, limit: limit))
    }

    func commentOnPost(postId: String, body: String, postRefId: String?) async throws -> MessagePublicDTO {
        try await client.request(.commentOnPost(postId: postId, body: body, postRefId: postRefId))
    }

    func likePost(postId: String) async throws {
        try await client.requestVoid(.likePost(postId: postId))
    }

    func unlikePost(postId: String) async throws {
        try await client.requestVoid(.unlikePost(postId: postId))
    }
}
