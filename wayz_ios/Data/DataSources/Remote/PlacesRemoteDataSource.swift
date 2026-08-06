//
//  PlacesRemoteDataSource.swift
//  wayz_ios
//

import Foundation

final class PlacesRemoteDataSource {
    private let client: APIClient
    private let isMock: Bool

    init(client: APIClient = .shared, isMock: Bool = AppConfig.current.isMockDataEnabled) {
        self.client = client
        self.isMock = isMock
    }

    func fetchPlaces(search: String?) async throws -> [PlaceDTO] {
        if isMock { return try await mockFetchPlaces(search: search) }
        return try await client.request(.getPlacesByName(name: search))
    }

    func searchNearby(lat: Double, lng: Double, radiusM: Int?, category: String?, name: String?) async throws -> [PlaceDTO] {
        if isMock { return try await mockFetchPlaces(search: name) }
        return try await client.request(.searchPlacesNearby(lat: lat, lng: lng, radiusM: radiusM, category: category, name: name))
    }

    func createPlace(
        name: String,
        description: String?,
        detail: String?,
        address: String?,
        category: String?,
        tags: [String],
        latitude: Double,
        longitude: Double
    ) async throws -> PlaceDTO {
        if isMock {
            return PlaceDTO(
                id: UUID().uuidString,
                name: name,
                description: description,
                detail: detail,
                address: address,
                category: category,
                tags: tags,
                latitude: latitude,
                longitude: longitude,
                images: [],
                avgRating: 0,
                reviewCount: 0,
                createdAt: "2026-08-05T12:00:00Z"
            )
        }
        var body: [String: Any] = ["name": name, "tags": tags, "latitude": latitude, "longitude": longitude]
        body["description"] = description
        body["detail"]      = detail
        body["address"]     = address
        body["category"]    = category
        return try await client.request(.createPlace(body: body))
    }

    func fetchPlaceDetail(id: String) async throws -> PlaceDTO {
        if isMock { return try await mockFetchPlaceDetail(id: id) }
        return try await client.request(.getPlaceDetail(placeId: id))
    }

    func fetchComments(placeId: String) async throws -> [CommentDTO] {
        if isMock { return try await mockFetchComments(placeId: placeId) }
        return try await client.request(.getPlaceComments(placeId: placeId))
    }

    /// `POST /places/{id}/comments` has no `images` field on the wire — folded
    /// into `meta_data` so already-uploaded image URLs still ride along.
    func postComment(placeId: String, parentCommentId: String?, text: String, imageURLs: [String]) async throws -> CommentDTO {
        if isMock { return try await mockPostComment(placeId: placeId, parentCommentId: parentCommentId, text: text, imageURLs: imageURLs) }
        return try await client.request(.addPlaceComment(placeId: placeId, text: text, metaData: imageURLs, parentId: parentCommentId))
    }

    func fetchImages(placeId: String) async throws -> [String] {
        if isMock { return try await mockFetchImages(placeId: placeId) }
        let media: [PlaceMediaDTO] = try await client.request(.getPlaceImages(placeId: placeId))
        return media.map(\.url)
    }
}

// MARK: - Mock errors

enum MockPlacesError: LocalizedError {
    case placeNotFound

    var errorDescription: String? {
        switch self {
        case .placeNotFound: return "This place could not be found."
        }
    }
}

// MARK: - Mock data

private extension PlacesRemoteDataSource {
    func mockFetchPlaces(search: String?) async throws -> [PlaceDTO] {
        try await Task.sleep(nanoseconds: 500_000_000)
        let places = Places.mockData
        guard let search, !search.isEmpty else {
            return places.map { PlaceDTO(place: $0) }
        }
        return places
            .filter { $0.name.localizedCaseInsensitiveContains(search) }
            .map { PlaceDTO(place: $0) }
    }

    func mockFetchPlaceDetail(id: String) async throws -> PlaceDTO {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let place = Places.mockData.first(where: { $0.id == id }) else {
            throw MockPlacesError.placeNotFound
        }
        return PlaceDTO(place: place)
    }

    func mockFetchComments(placeId: String) async throws -> [CommentDTO] {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let place = Places.mockData.first(where: { $0.id == placeId }) else {
            throw MockPlacesError.placeNotFound
        }
        return place.comments.flatMap { comment -> [CommentDTO] in
            [CommentDTO(placeId: placeId, comment: comment, parentId: nil)]
                + comment.replies.map { CommentDTO(placeId: placeId, comment: $0, parentId: comment.id) }
        }
    }

    /// Doesn't persist across calls — like `UserRemoteDataSource`'s mock, this
    /// just echoes back a well-formed response for UI wiring during development.
    func mockPostComment(placeId: String, parentCommentId: String?, text: String, imageURLs: [String]) async throws -> CommentDTO {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard Places.mockData.contains(where: { $0.id == placeId }) else {
            throw MockPlacesError.placeNotFound
        }
        return CommentDTO(
            id: UUID().uuidString,
            placeId: placeId,
            userId: "me",
            text: text,
            metaData: imageURLs,
            parentId: parentCommentId,
            createdAt: "2026-08-05T12:00:00Z"
        )
    }

    func mockFetchImages(placeId: String) async throws -> [String] {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let place = Places.mockData.first(where: { $0.id == placeId }) else {
            throw MockPlacesError.placeNotFound
        }
        return place.images + Self.flattenImageURLs(place.comments)
    }

    static func flattenImageURLs(_ comments: [Comment]) -> [String] {
        comments.flatMap { comment in
            comment.images + flattenImageURLs(comment.replies)
        }
    }
}

// MARK: - Domain → DTO (mock bridge)

/// Lets the mock path reuse `Places.mockData` — the same rich fixtures the
/// UI already runs against — instead of maintaining a second, parallel set
/// of raw DTO fixtures.
private extension PlaceDTO {
    init(place: Places) {
        self.init(
            id: place.id,
            name: place.name,
            description: place.description,
            detail: place.detail,
            address: place.address,
            category: place.category,
            tags: place.tags.isEmpty ? place.suitedFor : place.tags,
            latitude: place.latitude,
            longitude: place.longitude,
            images: place.images.enumerated().map { PlaceImageDTO(url: $0.element, order: $0.offset) },
            avgRating: place.avgRating > 0 ? place.avgRating : Double(place.rating),
            reviewCount: place.reviewCount,
            createdAt: place.createdAt
        )
    }
}

private extension CommentDTO {
    init(placeId: String, comment: Comment, parentId: String?) {
        self.init(
            id: comment.id,
            placeId: placeId,
            userId: comment.userId ?? comment.authorName,
            text: comment.text,
            metaData: comment.images,
            parentId: parentId,
            createdAt: comment.date
        )
    }
}
