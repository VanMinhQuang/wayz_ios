//
//  UserRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol UserRepositoryProtocol {
    func fetchUser(id: String) async throws -> User
    func login(email: String, password: String) async throws -> AuthToken
}
