//
//  StoryMapper.swift
//  wayz_ios
//

enum StoryMapper {
    static func toEntity(_ dto: StoryPublicDTO) -> Story {
        Story(
            id: dto.id,
            userId: dto.userId,
            type: StoryType(rawValue: dto.type) ?? .text,
            mediaURL: dto.mediaURL,
            textContent: dto.textContent,
            background: dto.background,
            musicURL: dto.musicURL,
            viewCount: dto.viewCount,
            viewedByMe: dto.viewedByMe,
            createdAt: dto.createdAt,
            expiresAt: dto.expiresAt
        )
    }
}

enum StoryTrayMapper {
    static func toEntity(_ dto: StoryTrayUserDTO) -> StoryTrayUser {
        StoryTrayUser(
            userId: dto.userId,
            username: dto.username,
            avatarURL: dto.avatarURL,
            hasUnviewed: dto.hasUnviewed,
            latestStoryAt: dto.latestStoryAt
        )
    }
}

enum StoryViewerMapper {
    static func toEntity(_ dto: StoryViewerPublicDTO) -> StoryViewer {
        StoryViewer(
            userId: dto.userId,
            username: dto.username,
            avatarURL: dto.avatarURL,
            viewedAt: dto.viewedAt
        )
    }
}
