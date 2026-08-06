//
//  GetPlaceReviewsUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetPlaceReviewsUseCase {
    private let repository: ReviewsRepositoryProtocol

    init(repository: ReviewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeId: String) async throws -> [Review] {
        try await repository.fetchReviews(placeId: placeId)
    }
}
