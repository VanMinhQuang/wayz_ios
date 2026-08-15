//
//  SocialRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol SocialRepositoryProtocol {
    // Follows
    func follow(userId: String) async throws
    func unfollow(userId: String) async throws
    func fetchFollowers(userId: String) async throws -> [User]
    func fetchFollowing(userId: String) async throws -> [User]

    // Blocks (§4 in API docs). Blocking is one-directional to create but
    // treated as mutual for every visibility check (chat, story, profile).
    // Following edges between the two users are removed on block.
    func block(userId: String) async throws
    func unblock(userId: String) async throws
    func fetchBlockedUsers() async throws -> [User]
}
