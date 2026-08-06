//
//  SocialRemoteDataSource.swift
//  wayz_ios
//

final class SocialRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func follow(userId: String) async throws {
        try await client.requestVoid(.followUser(userId: userId))
    }

    func unfollow(userId: String) async throws {
        try await client.requestVoid(.unfollowUser(userId: userId))
    }

    func fetchFollowers(userId: String) async throws -> [UserPublicDTO] {
        try await client.request(.getFollowers(userId: userId))
    }

    func fetchFollowing(userId: String) async throws -> [UserPublicDTO] {
        try await client.request(.getFollowing(userId: userId))
    }
}
