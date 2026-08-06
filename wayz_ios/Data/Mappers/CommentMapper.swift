//
//  CommentMapper.swift
//  wayz_ios
//

enum CommentMapper {
    /// `PlaceCommentPublic` has no author name/avatar/rating — those UI-facing
    /// fields fall back to the raw `userId` / empty, since rendering a real
    /// display name would require joining against the user profile endpoint.
    static func toEntity(_ dto: CommentDTO, replies: [Comment] = []) -> Comment {
        Comment(
            id: dto.id,
            authorName: dto.userId,
            authorAvatarURL: "",
            date: dto.createdAt,
            text: dto.text,
            replies: replies,
            userId: dto.userId,
            placeId: dto.placeId,
            parentId: dto.parentId,
            metaData: dto.metaData
        )
    }

    /// `GET /places/{id}/comments` returns a flat list threaded by `parentId`;
    /// this rebuilds the two-level tree (`Comment.replies`) the UI expects.
    static func toTree(_ dtos: [CommentDTO]) -> [Comment] {
        let repliesByParent = Dictionary(grouping: dtos.filter { $0.parentId != nil }) { $0.parentId! }
        return dtos
            .filter { $0.parentId == nil }
            .map { dto in
                toEntity(dto, replies: (repliesByParent[dto.id] ?? []).map { toEntity($0) })
            }
    }
}
