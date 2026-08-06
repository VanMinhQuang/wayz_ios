//
//  UploadsRemoteDataSource.swift
//  wayz_ios
//

final class UploadsRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func presign(contentType: String, folder: String) async throws -> PresignedUploadDTO {
        try await client.request(.presignUpload(contentType: contentType, folder: folder))
    }
}
