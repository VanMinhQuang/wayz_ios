//
//  GetPlaceCommentsUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetPlaceCommentsUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeId: String) async throws -> [Comment] {
        try await repository.fetchComments(placeId: placeId)
    }
}
