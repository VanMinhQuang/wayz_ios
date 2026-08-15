//
//  StoryDTO.swift
//  wayz_ios
//
//  Wire schemas for the Stories resource (doc §8, §12).
//

/// `StoryPublic` — pushed by `POST /stories`, `GET /users/{id}/stories`, etc.
struct StoryPublicDTO: Codable {
    let id: String
    let userId: String
    let type: String              // "text" | "image" | "video"
    let mediaURL: String?
    let textContent: String?
    let background: String?
    let musicURL: String?
    let viewCount: Int
    let viewedByMe: Bool
    let createdAt: String
    let expiresAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId       = "user_id"
        case type
        case mediaURL     = "media_url"
        case textContent  = "text_content"
        case background
        case musicURL     = "music_url"
        case viewCount    = "view_count"
        case viewedByMe   = "viewed_by_me"
        case createdAt    = "created_at"
        case expiresAt    = "expires_at"
    }
}

/// One tray entry — `GET /stories/tray` response element (doc §8.3).
struct StoryTrayUserDTO: Codable {
    let userId: String
    let username: String
    let avatarURL: String?
    let hasUnviewed: Bool
    let latestStoryAt: String

    enum CodingKeys: String, CodingKey {
        case userId         = "user_id"
        case username
        case avatarURL      = "avatar_url"
        case hasUnviewed    = "has_unviewed"
        case latestStoryAt  = "latest_story_at"
    }
}

/// `StoryViewerPublic` — one viewer, from `GET /stories/{id}/viewers` (doc §8.6).
struct StoryViewerPublicDTO: Codable {
    let userId: String
    let username: String
    let avatarURL: String?
    let viewedAt: String

    enum CodingKeys: String, CodingKey {
        case userId     = "user_id"
        case username
        case avatarURL  = "avatar_url"
        case viewedAt   = "viewed_at"
    }
}
