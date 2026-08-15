//
//  Story.swift
//  wayz_ios
//
//  Domain entity — mirrors `StoryPublic` (doc §12). Text stories carry a
//  `background` id (gradient / color name) and `textContent`; image/video
//  stories carry a `mediaURL`. Any story type may include an optional
//  `musicURL` for background audio.
//

enum StoryType: String, Codable {
    case text
    case image
    case video
}

struct Story: Identifiable {
    let id: String
    let userId: String
    let type: StoryType
    let mediaURL: String?
    let textContent: String?
    let background: String?
    let musicURL: String?
    let viewCount: Int
    let viewedByMe: Bool
    let createdAt: String
    let expiresAt: String
}

/// One tray entry — a user + how recent their most recent story is (doc §12).
struct StoryTrayUser: Identifiable {
    var id: String { userId }
    let userId: String
    let username: String
    let avatarURL: String?
    let hasUnviewed: Bool
    let latestStoryAt: String
}

/// One viewer entry (doc §12). One-line struct — the person who watched a story.
struct StoryViewer: Identifiable {
    var id: String { userId }
    let userId: String
    let username: String
    let avatarURL: String?
    let viewedAt: String
}
