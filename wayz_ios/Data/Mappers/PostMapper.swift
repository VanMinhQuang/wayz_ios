//
//  PostMapper.swift
//  wayz_ios
//

enum PostMapper {
    static func toEntity(_ dto: PostDTO) -> Post {
        Post(
            id: dto.id,
            userId: dto.userId,
            imageURL: dto.imageURL,
            caption: dto.caption,
            placeId: dto.placeId,
            likeCount: dto.likeCount,
            likedByMe: dto.likedByMe,
            createdAt: dto.createdAt
        )
    }
}
