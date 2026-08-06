//
//  GetPlaceImagesUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetPlaceImagesUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    /// Every photo for a place — its own gallery plus every comment's photos,
    /// merged server-side. Kept separate from `GetPlaceCommentsUseCase` so a
    /// pure photo grid doesn't have to pull down comment text to render.
    func execute(placeId: String) async throws -> [String] {
        try await repository.fetchImages(placeId: placeId)
    }
}
