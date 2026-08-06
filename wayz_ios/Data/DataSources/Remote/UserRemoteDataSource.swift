//
//  UserRemoteDataSource.swift
//  wayz_ios
//

import Foundation

final class UserRemoteDataSource {
    private let client: APIClient
    private let isMock: Bool

    init(client: APIClient = .shared, isMock: Bool = AppConfig.current.isMockDataEnabled) {
        self.client = client
        self.isMock = isMock
    }

    func register(email: String, username: String, password: String, fullName: String) async throws -> UserDTO {
        if isMock { return try await mockRegister(email: email, username: username, password: password, fullName: fullName) }
        return try await client.request(.register(email: email, username: username, password: password, fullName: fullName))
    }

    func login(email: String, password: String) async throws -> TokenDTO {
        if isMock { return try await mockLogin(email: email, password: password) }
        return try await client.request(.login(email: email, password: password))
    }

    func refreshToken(_ refreshToken: String) async throws -> TokenDTO {
        if isMock { return Self.fakeToken }
        return try await client.request(.refreshToken(token: refreshToken))
    }

    func getMe() async throws -> UserDTO {
        if isMock { return try await mockFetchUser(id: "me") }
        return try await client.request(.getMe)
    }

    func updateMe(body: [String: Any]) async throws -> UserDTO {
        if isMock { return try await mockUpdateMe(body: body) }
        return try await client.request(.updateMe(body: body))
    }

    func getPublicProfile(username: String) async throws -> UserPublicDTO {
        if isMock { return try await mockPublicProfile(username: username) }
        return try await client.request(.getPublicProfile(username: username))
    }
}

// MARK: - Mock errors

enum MockAuthError: LocalizedError {
    case accountNotFound
    case wrongPassword

    var errorDescription: String? {
        switch self {
        case .accountNotFound: return "Account not found. Please check your email."
        case .wrongPassword:   return "Incorrect password. Please try again."
        }
    }
}

// MARK: - Mock data

private extension UserRemoteDataSource {
    static var fakeUsers: [String: UserDTO] = [
        "me": UserDTO(
            id: "me",
            username: "quang_dev",
            email: "quang.van@hctech.com.vn",
            fullName: "Quang Van",
            bio: nil,
            avatarURL: "https://i.pravatar.cc/150?u=quang",
            isPrivate: false,
            createdAt: "2026-08-05T12:00:00Z"
        ),
        "u1": UserDTO(
            id: "u1",
            username: "alice_nguyen",
            email: "alice@wayz.com",
            fullName: "Alice Nguyen",
            bio: nil,
            avatarURL: "https://i.pravatar.cc/150?u=alice",
            isPrivate: false,
            createdAt: "2026-08-05T12:00:00Z"
        ),
        "u2": UserDTO(
            id: "u2",
            username: "bob_tran",
            email: "bob@wayz.com",
            fullName: "Bob Tran",
            bio: nil,
            avatarURL: nil,
            isPrivate: false,
            createdAt: "2026-08-05T12:00:00Z"
        )
    ]

    // email → password
    static let fakeCredentials: [String: String] = [
        "quang.van@hctech.com.vn": "password123",
        "alice@wayz.com":          "password123",
        "bob@wayz.com":            "password123"
    ]

    static let fakeToken = TokenDTO(
        accessToken: "mock-access-token-abc123",
        refreshToken: "mock-refresh-token-xyz789",
        tokenType: "bearer"
    )

    func mockRegister(email: String, username: String, password: String, fullName: String) async throws -> UserDTO {
        try await Task.sleep(nanoseconds: 800_000_000)
        let user = UserDTO(
            id: UUID().uuidString,
            username: username,
            email: email,
            fullName: fullName,
            bio: nil,
            avatarURL: nil,
            isPrivate: false,
            createdAt: "2026-08-05T12:00:00Z"
        )
        Self.fakeUsers[user.id] = user
        return user
    }

    func mockFetchUser(id: String) async throws -> UserDTO {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard let user = Self.fakeUsers[id] else {
            throw MockAuthError.accountNotFound
        }
        return user
    }

    func mockUpdateMe(body: [String: Any]) async throws -> UserDTO {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let existing = Self.fakeUsers["me"] else {
            throw MockAuthError.accountNotFound
        }
        let updated = UserDTO(
            id: existing.id,
            username: existing.username,
            email: existing.email,
            fullName: body["full_name"] as? String ?? existing.fullName,
            bio: body["bio"] as? String ?? existing.bio,
            avatarURL: body["avatar_url"] as? String ?? existing.avatarURL,
            isPrivate: body["is_private"] as? Bool ?? existing.isPrivate,
            createdAt: existing.createdAt
        )
        Self.fakeUsers["me"] = updated
        return updated
    }

    func mockPublicProfile(username: String) async throws -> UserPublicDTO {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let user = Self.fakeUsers.values.first(where: { $0.username == username }) else {
            throw MockAuthError.accountNotFound
        }
        return UserPublicDTO(
            id: user.id,
            username: user.username,
            fullName: user.fullName,
            bio: user.bio,
            avatarURL: user.avatarURL,
            isPrivate: user.isPrivate,
            createdAt: user.createdAt
        )
    }

    func mockLogin(email: String, password: String) async throws -> TokenDTO {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard let storedPassword = Self.fakeCredentials[email] else {
            throw MockAuthError.accountNotFound
        }
        guard storedPassword == password else {
            throw MockAuthError.wrongPassword
        }
        return Self.fakeToken
    }
}
