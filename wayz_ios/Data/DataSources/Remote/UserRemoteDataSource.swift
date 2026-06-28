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

    func fetchUser(id: String) async throws -> UserDTO {
        if isMock { return try await mockFetchUser(id: id) }
        return try await client.request(.getUser(id: id))
    }

    func login(email: String, password: String) async throws -> TokenDTO {
        if isMock { return try await mockLogin(email: email, password: password) }
        return try await client.request(.login(email: email, password: password))
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
    static let fakeUsers: [String: UserDTO] = [
        "me": UserDTO(
            id: "me",
            fullName: "Quang Van",
            email: "quang.van@hctech.com.vn",
            avatarURL: "https://i.pravatar.cc/150?u=quang"
        ),
        "u1": UserDTO(
            id: "u1",
            fullName: "Alice Nguyen",
            email: "alice@wayz.com",
            avatarURL: "https://i.pravatar.cc/150?u=alice"
        ),
        "u2": UserDTO(
            id: "u2",
            fullName: "Bob Tran",
            email: "bob@wayz.com",
            avatarURL: nil
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
        refreshToken: "mock-refresh-token-xyz789"
    )

    func mockFetchUser(id: String) async throws -> UserDTO {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard let user = Self.fakeUsers[id] else {
            throw MockAuthError.accountNotFound
        }
        return user
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
