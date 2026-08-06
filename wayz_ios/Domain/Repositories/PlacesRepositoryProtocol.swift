//
//  PlacesRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol PlacesRepositoryProtocol {
    func fetchPlaces(search: String?) async throws -> [Places]
    func searchNearby(lat: Double, lng: Double, radiusM: Int?, category: String?, name: String?) async throws -> [Places]
    func createPlace(
        name: String,
        description: String?,
        detail: String?,
        address: String?,
        category: String?,
        tags: [String],
        latitude: Double,
        longitude: Double
    ) async throws -> Places
    func fetchPlaceDetail(id: String) async throws -> Places
    func fetchComments(placeId: String) async throws -> [Comment]
    func postComment(placeId: String, parentCommentId: String?, text: String, imageURLs: [String]) async throws -> Comment
    func fetchImages(placeId: String) async throws -> [String]
}
