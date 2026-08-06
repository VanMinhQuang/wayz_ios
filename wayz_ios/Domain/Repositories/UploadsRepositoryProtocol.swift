//
//  UploadsRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol UploadsRepositoryProtocol {
    func presign(contentType: String, folder: String) async throws -> PresignedUpload
}
