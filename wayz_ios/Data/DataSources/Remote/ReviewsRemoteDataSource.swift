//
//  ReviewsRemoteDataSource.swift
//  wayz_ios
//

final class ReviewsRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchReviews(placeId: String) async throws -> [ReviewDTO] {
        try await client.request(.getPlaceReviews(placeId: placeId))
    }

    func addReview(placeId: String, rating: Int, comment: String) async throws -> ReviewDTO {
        try await client.request(.addPlaceReview(placeId: placeId, rating: rating, comment: comment))
    }
}
