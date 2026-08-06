//
//  ReviewsRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol ReviewsRepositoryProtocol {
    func fetchReviews(placeId: String) async throws -> [Review]
    func addReview(placeId: String, rating: Int, comment: String) async throws -> Review
}
