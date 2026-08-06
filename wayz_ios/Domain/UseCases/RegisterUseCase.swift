//
//  RegisterUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class RegisterUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, username: String, password: String, fullName: String) async throws -> User {
        try await repository.register(email: email, username: username, password: password, fullName: fullName)
    }
}
