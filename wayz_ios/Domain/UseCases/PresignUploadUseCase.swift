//
//  PresignUploadUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class PresignUploadUseCase {
    private let repository: UploadsRepositoryProtocol

    init(repository: UploadsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(contentType: String, folder: String) async throws -> PresignedUpload {
        try await repository.presign(contentType: contentType, folder: folder)
    }
}
