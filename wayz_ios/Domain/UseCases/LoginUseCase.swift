//
//  LoginUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class LoginUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> AuthToken {
        try await repository.login(email: email, password: password)
    }
}
