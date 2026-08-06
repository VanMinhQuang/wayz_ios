//
//  RefreshTokenUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class RefreshTokenUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> AuthToken {
        try await repository.refreshToken()
    }
}
