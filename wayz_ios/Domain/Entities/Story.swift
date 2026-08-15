//
//  UserStory.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

enum StoryMediaKind: String {
    case image
    case video
    case text
}

enum StoryPrivacy: String {
    case publicAll      = "public"
    case friends
    case closeFriends   = "close_friends"
    case custom
}

struct StoryReaction: Identifiable {
    let id: String
    let userId: String
    let emoji: String
    let createdAt: String
}

struct StoryViewer: Identifiable {
    let id: String
    let userId: String
    let viewedAt: String
}

struct StoryMention: Identifiable {
    let id: String
    let userId: String
    let username: String
}

struct StorySticker: Identifiable {
    let id: String
    let kind: String
    let text: String?
    let x: Double
    let y: Double
    let rotation: Double
    let scale: Double
}

struct Story: Identifiable {
    // Identity
    let id: String
    let authorId: String

    // Content
    let mediaKind: StoryMediaKind
    let mediaURL: String?
    let thumbnailURL: String?
    let width: Int?
    let height: Int?

    // Playback
    /// Display duration in seconds. For images, defaults to ~5s;
    /// for videos, this equals the clip length.
    let durationSeconds: Double
    let mutedByDefault: Bool

    // Text / overlays
    let caption: String?
    let textColorHex: String?
    let backgroundColorHex: String?
    let fontName: String?
    let stickers: [StorySticker]
    let mentions: [StoryMention]

    // Context
    let placeId: String?
    let postRefId: String?
    let musicTrackId: String?

    // Audience & moderation
    let privacy: StoryPrivacy
    let allowReplies: Bool
    let allowReactions: Bool
    let isArchived: Bool

    // Engagement
    let viewCount: Int
    let viewedByMe: Bool
    let reactionCount: Int
    let reactedByMe: Bool
    let recentReactions: [StoryReaction]

    // Lifetime
    let createdAt: String
    let expiresAt: String
}
