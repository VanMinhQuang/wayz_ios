//
//  CreatePlaceUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class CreatePlaceUseCase {
    private let repository: PlacesRepositoryProtocol

    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        name: String,
        description: String? = nil,
        detail: String? = nil,
        address: String? = nil,
        category: String? = nil,
        tags: [String] = [],
        latitude: Double,
        longitude: Double
    ) async throws -> Places {
        try await repository.createPlace(
            name: name,
            description: description,
            detail: detail,
            address: address,
            category: category,
            tags: tags,
            latitude: latitude,
            longitude: longitude
        )
    }
}
