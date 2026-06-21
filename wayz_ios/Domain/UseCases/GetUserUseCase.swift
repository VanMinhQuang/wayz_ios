//
//  GetUserUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetUserUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws -> User {
        try await repository.fetchUser(id: id)
    }
}
