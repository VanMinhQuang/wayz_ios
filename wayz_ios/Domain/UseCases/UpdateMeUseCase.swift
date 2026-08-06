//
//  UpdateMeUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class UpdateMeUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        fullName: String? = nil,
        bio: String? = nil,
        avatarURL: String? = nil,
        isPrivate: Bool? = nil
    ) async throws -> User {
        try await repository.updateMe(fullName: fullName, bio: bio, avatarURL: avatarURL, isPrivate: isPrivate)
    }
}
