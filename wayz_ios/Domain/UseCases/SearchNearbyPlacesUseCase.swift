//
//  SearchNearbyPlacesUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class SearchNearbyPlacesUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        lat: Double,
        lng: Double,
        radiusM: Int? = nil,
        category: String? = nil,
        name: String? = nil
    ) async throws -> [Places] {
        try await repository.searchNearby(lat: lat, lng: lng, radiusM: radiusM, category: category, name: name)
    }
}
