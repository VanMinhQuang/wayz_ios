//
//  PostPlaceCommentUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class PostPlaceCommentUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    /// - Parameter parentCommentId: pass the top-level comment's id to post a
    ///   reply, or `nil` to post a new top-level comment.
    /// - Parameter imageURLs: URLs of images already uploaded to storage —
    ///   uploading locally-picked photos is a separate concern (e.g. a future
    ///   `PlacesRepositoryProtocol.uploadImage(data:)`), not this use case.
    func execute(placeId: String, parentCommentId: String? = nil, text: String, imageURLs: [String] = []) async throws -> Comment {
        try await repository.postComment(placeId: placeId, parentCommentId: parentCommentId, text: text, imageURLs: imageURLs)
    }
}
