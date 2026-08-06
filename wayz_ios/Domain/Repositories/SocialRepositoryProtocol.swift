//
//  SocialRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol SocialRepositoryProtocol {
    func follow(userId: String) async throws
    func unfollow(userId: String) async throws
    func fetchFollowers(userId: String) async throws -> [User]
    func fetchFollowing(userId: String) async throws -> [User]
}
