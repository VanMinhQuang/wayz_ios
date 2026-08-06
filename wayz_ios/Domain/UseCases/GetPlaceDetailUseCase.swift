//
//  GetPlaceDetailUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetPlaceDetailUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws -> Places {
        try await repository.fetchPlaceDetail(id: id)
    }
}
