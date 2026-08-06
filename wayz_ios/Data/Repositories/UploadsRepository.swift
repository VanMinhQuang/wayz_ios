//
//  UploadsRepository.swift
//  wayz_ios
//

final class UploadsRepository: UploadsRepositoryProtocol {
    private let remoteDataSource: UploadsRemoteDataSource

    init(remoteDataSource: UploadsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func presign(contentType: String, folder: String) async throws -> PresignedUpload {
        let dto = try await remoteDataSource.presign(contentType: contentType, folder: folder)
        return UploadMapper.toEntity(dto)
    }
}
