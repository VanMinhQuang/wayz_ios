//
//  PostsRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol PostsRepositoryProtocol {
    func createPost(imageURL: String, caption: String?, placeId: String?) async throws -> Post
    func deletePost(postId: String) async throws
    func fetchFeed(limit: Int) async throws -> [Post]
    func fetchPosts(userId: String, limit: Int) async throws -> [Post]
    func commentOnPost(postId: String, body: String, postRefId: String?) async throws -> Message
    func likePost(postId: String) async throws
    func unlikePost(postId: String) async throws
}
