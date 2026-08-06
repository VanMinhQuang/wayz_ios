//
//  PostsRepository.swift
//  wayz_ios
//

final class PostsRepository: PostsRepositoryProtocol {
    private let remoteDataSource: PostsRemoteDataSource

    init(remoteDataSource: PostsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func createPost(imageURL: String, caption: String?, placeId: String?) async throws -> Post {
        let dto = try await remoteDataSource.createPost(imageURL: imageURL, caption: caption, placeId: placeId)
        return PostMapper.toEntity(dto)
    }

    func deletePost(postId: String) async throws {
        try await remoteDataSource.deletePost(postId: postId)
    }

    func fetchFeed(limit: Int) async throws -> [Post] {
        try await remoteDataSource.fetchFeed(limit: limit).map(PostMapper.toEntity)
    }

    func fetchPosts(userId: String, limit: Int) async throws -> [Post] {
        try await remoteDataSource.fetchPosts(userId: userId, limit: limit).map(PostMapper.toEntity)
    }

    func commentOnPost(postId: String, body: String, postRefId: String?) async throws -> Message {
        let dto = try await remoteDataSource.commentOnPost(postId: postId, body: body, postRefId: postRefId)
        return MessageMapper.toEntity(dto)
    }

    func likePost(postId: String) async throws {
        try await remoteDataSource.likePost(postId: postId)
    }

    func unlikePost(postId: String) async throws {
        try await remoteDataSource.unlikePost(postId: postId)
    }
}
