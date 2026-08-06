//
//  PlacesRepository.swift
//  wayz_ios
//

final class PlacesRepository: PlacesRepositoryProtocol {
    private let remoteDataSource: PlacesRemoteDataSource
    private let localDataSource: PlacesLocalDataSource

    init(remoteDataSource: PlacesRemoteDataSource, localDataSource: PlacesLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource  = localDataSource
    }

    func fetchPlaces(search: String?) async throws -> [Places] {
        // Only the unfiltered list is cached — search results always hit the network.
        if let cached = localDataSource.getPlaces(search: search) {
            return cached
        }
        let dtos     = try await remoteDataSource.fetchPlaces(search: search)
        let entities = dtos.map { PlaceMapper.toEntity($0) }
        localDataSource.savePlaces(entities, search: search)
        return entities
    }

    func searchNearby(lat: Double, lng: Double, radiusM: Int?, category: String?, name: String?) async throws -> [Places] {
        let dtos = try await remoteDataSource.searchNearby(lat: lat, lng: lng, radiusM: radiusM, category: category, name: name)
        return dtos.map { PlaceMapper.toEntity($0) }
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
    ) async throws -> Places {
        let dto = try await remoteDataSource.createPlace(
            name: name,
            description: description,
            detail: detail,
            address: address,
            category: category,
            tags: tags,
            latitude: latitude,
            longitude: longitude
        )
        return PlaceMapper.toEntity(dto)
    }

    func fetchPlaceDetail(id: String) async throws -> Places {
        if let cached = localDataSource.getPlaceDetail(id: id) {
            return cached
        }
        let dto    = try await remoteDataSource.fetchPlaceDetail(id: id)
        let entity = PlaceMapper.toEntity(dto)
        localDataSource.savePlaceDetail(entity)
        return entity
    }

    func fetchComments(placeId: String) async throws -> [Comment] {
        if let cached = localDataSource.getComments(placeId: placeId) {
            return cached
        }
        let dtos     = try await remoteDataSource.fetchComments(placeId: placeId)
        let entities = CommentMapper.toTree(dtos)
        localDataSource.saveComments(entities, placeId: placeId)
        return entities
    }

    func postComment(placeId: String, parentCommentId: String?, text: String, imageURLs: [String]) async throws -> Comment {
        let dto = try await remoteDataSource.postComment(
            placeId: placeId,
            parentCommentId: parentCommentId,
            text: text,
            imageURLs: imageURLs
        )
        let comment = CommentMapper.toEntity(dto)

        // Keep the cache coherent so a subsequent `fetchComments` reflects the post.
        if var comments = localDataSource.getComments(placeId: placeId) {
            if let parentCommentId, let index = comments.firstIndex(where: { $0.id == parentCommentId }) {
                comments[index].replies.append(comment)
            } else {
                comments.append(comment)
            }
            localDataSource.saveComments(comments, placeId: placeId)
        }

        return comment
    }

    func fetchImages(placeId: String) async throws -> [String] {
        try await remoteDataSource.fetchImages(placeId: placeId)
    }
}
