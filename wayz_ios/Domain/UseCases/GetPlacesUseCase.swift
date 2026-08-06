//
//  GetPlacesUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetPlacesUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(search: String? = nil) async throws -> [Places] {
        try await repository.fetchPlaces(search: search)
    }
}
