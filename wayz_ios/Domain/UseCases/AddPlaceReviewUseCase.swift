//
//  AddPlaceReviewUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class AddPlaceReviewUseCase {
    private let repository: ReviewsRepositoryProtocol

    init(repository: ReviewsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeId: String, rating: Int, comment: String) async throws -> Review {
        try await repository.addReview(placeId: placeId, rating: rating, comment: comment)
    }
}
