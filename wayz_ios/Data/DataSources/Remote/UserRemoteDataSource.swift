//
//  UserRemoteDataSource.swift
//  wayz_ios
//

final class UserRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchUser(id: String) async throws -> UserDTO {
        try await client.request(.getUser(id: id))
    }

    func login(email: String, password: String) async throws -> TokenDTO {
        try await client.request(.login(email: email, password: password))
    }
}
