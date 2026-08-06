//
//  UserRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol UserRepositoryProtocol {
    func register(email: String, username: String, password: String, fullName: String) async throws -> User
    func login(email: String, password: String) async throws -> AuthToken
    func refreshToken() async throws -> AuthToken

    /// Pass `"me"` for the signed-in user's full profile (`GET /users/me`);
    /// any other value is treated as a username and resolves via the public
    /// profile endpoint (`GET /users/{username}`, no `email` on the result).
    func fetchUser(id: String) async throws -> User
    func updateMe(fullName: String?, bio: String?, avatarURL: String?, isPrivate: Bool?) async throws -> User
}
