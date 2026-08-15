//
//  SocialRepository.swift
//  wayz_ios
//

final class SocialRepository: SocialRepositoryProtocol {
    private let remoteDataSource: SocialRemoteDataSource

    init(remoteDataSource: SocialRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func follow(userId: String) async throws {
        try await remoteDataSource.follow(userId: userId)
    }

    func unfollow(userId: String) async throws {
        try await remoteDataSource.unfollow(userId: userId)
    }

    func fetchFollowers(userId: String) async throws -> [User] {
        try await remoteDataSource.fetchFollowers(userId: userId).map(UserMapper.toEntity)
    }

    func fetchFollowing(userId: String) async throws -> [User] {
        try await remoteDataSource.fetchFollowing(userId: userId).map(UserMapper.toEntity)
    }

    // MARK: - Blocks

    func block(userId: String) async throws {
        try await remoteDataSource.block(userId: userId)
    }

    func unblock(userId: String) async throws {
        try await remoteDataSource.unblock(userId: userId)
    }

    func fetchBlockedUsers() async throws -> [User] {
        try await remoteDataSource.fetchBlockedUsers().map(UserMapper.toEntity)
    }
}
