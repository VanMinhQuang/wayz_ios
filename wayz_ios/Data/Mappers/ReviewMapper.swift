//
//  ReviewMapper.swift
//  wayz_ios
//

enum ReviewMapper {
    static func toEntity(_ dto: ReviewDTO) -> Review {
        Review(
            id: dto.id,
            placeId: dto.placeId,
            userId: dto.userId,
            rating: dto.rating,
            comment: dto.comment,
            createdAt: dto.createdAt
        )
    }
}
