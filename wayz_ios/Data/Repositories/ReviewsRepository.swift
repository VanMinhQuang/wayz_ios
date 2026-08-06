//
//  ReviewsRepository.swift
//  wayz_ios
//

final class ReviewsRepository: ReviewsRepositoryProtocol {
    private let remoteDataSource: ReviewsRemoteDataSource

    init(remoteDataSource: ReviewsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchReviews(placeId: String) async throws -> [Review] {
        try await remoteDataSource.fetchReviews(placeId: placeId).map(ReviewMapper.toEntity)
    }

    func addReview(placeId: String, rating: Int, comment: String) async throws -> Review {
        let dto = try await remoteDataSource.addReview(placeId: placeId, rating: rating, comment: comment)
        return ReviewMapper.toEntity(dto)
    }
}
