//
//  UserStory+Mock.swift
//  wayz_ios
//
//  Dummy stories linked to `UserChat.mockUsers` via `authorId`.
//  Gate usage behind `AppConfig.current.isMockDataEnabled` where appropriate.
//

extension Story {
    /// All mock stories, ordered oldest → newest per author. Author IDs match
    /// `UserChat.mockUsers[*].id` / `UserChat.mockCurrentUser.id`.
    static let mockData: [Story] = [
        // MARK: user_me (Tôi) — 1 text story with background music
        Story(
            id: "story_me_001",
            authorId: "user_me",
            mediaKind: .text,
            mediaURL: nil,
            thumbnailURL: nil,
            width: 1080,
            height: 1920,
            durationSeconds: 6,
            mutedByDefault: false,
            caption: "Chào buổi sáng mọi người ☀️",
            textColorHex: "#FFFFFF",
            backgroundColorHex: "#FF6B6B",
            fontName: "SF Pro Rounded",
            stickers: [],
            mentions: [],
            placeId: nil,
            postRefId: nil,
            musicTrackId: "track_001",
            privacy: .friends,
            allowReplies: true,
            allowReactions: true,
            isArchived: false,
            viewCount: 12,
            viewedByMe: true,
            reactionCount: 3,
            reactedByMe: false,
            recentReactions: [],
            createdAt: "2026-08-15T07:20:00Z",
            expiresAt: "2026-08-16T07:20:00Z"
        ),

        // MARK: user_001 (Nguyễn Văn Minh Quang) — image + video
        Story(
            id: "story_001_a",
            authorId: "user_001",
            mediaKind: .image,
            mediaURL: "https://picsum.photos/seed/quang1/1080/1920",
            thumbnailURL: "https://picsum.photos/seed/quang1/216/384",
            width: 1080,
            height: 1920,
            durationSeconds: 5,
            mutedByDefault: true,
            caption: "Cà phê sáng ☕️",
            textColorHex: nil,
            backgroundColorHex: nil,
            fontName: nil,
            stickers: [
                StorySticker(id: "stk_001", kind: "location", text: "The Coffee House", x: 0.5, y: 0.85, rotation: 0, scale: 1)
            ],
            mentions: [],
            placeId: "place_001",
            postRefId: nil,
            musicTrackId: nil,
            privacy: .publicAll,
            allowReplies: true,
            allowReactions: true,
            isArchived: false,
            viewCount: 128,
            viewedByMe: false,
            reactionCount: 24,
            reactedByMe: false,
            recentReactions: [
                StoryReaction(id: "rx_001", userId: "user_002", emoji: "❤️", createdAt: "2026-08-15T08:12:00Z"),
                StoryReaction(id: "rx_002", userId: "user_004", emoji: "🔥", createdAt: "2026-08-15T08:15:00Z")
            ],
            createdAt: "2026-08-15T08:00:00Z",
            expiresAt: "2026-08-16T08:00:00Z"
        ),
        Story(
            id: "story_001_b",
            authorId: "user_001",
            mediaKind: .video,
            mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            thumbnailURL: "https://picsum.photos/seed/quang2/216/384",
            width: 1080,
            height: 1920,
            durationSeconds: 12,
            mutedByDefault: false,
            caption: "Chuyến đi cuối tuần 🏞️",
            textColorHex: nil,
            backgroundColorHex: nil,
            fontName: nil,
            stickers: [],
            mentions: [
                StoryMention(id: "mt_001", userId: "user_003", username: "hoangnam")
            ],
            placeId: nil,
            postRefId: "post_001",
            musicTrackId: "track_001",
            privacy: .publicAll,
            allowReplies: true,
            allowReactions: true,
            isArchived: false,
            viewCount: 87,
            viewedByMe: false,
            reactionCount: 15,
            reactedByMe: false,
            recentReactions: [],
            createdAt: "2026-08-15T09:30:00Z",
            expiresAt: "2026-08-16T09:30:00Z"
        ),

        // MARK: user_002 (Trần Thị Lan) — 1 image
        Story(
            id: "story_002_a",
            authorId: "user_002",
            mediaKind: .image,
            mediaURL: "https://picsum.photos/seed/lan1/1080/1920",
            thumbnailURL: "https://picsum.photos/seed/lan1/216/384",
            width: 1080,
            height: 1920,
            durationSeconds: 5,
            mutedByDefault: true,
            caption: "Chiều nay đẹp quá 🌅",
            textColorHex: nil,
            backgroundColorHex: nil,
            fontName: nil,
            stickers: [],
            mentions: [],
            placeId: nil,
            postRefId: nil,
            musicTrackId: "track_002",
            privacy: .friends,
            allowReplies: true,
            allowReactions: true,
            isArchived: false,
            viewCount: 42,
            viewedByMe: true,
            reactionCount: 6,
            reactedByMe: true,
            recentReactions: [
                StoryReaction(id: "rx_003", userId: "user_me", emoji: "😍", createdAt: "2026-08-15T10:05:00Z")
            ],
            createdAt: "2026-08-15T10:00:00Z",
            expiresAt: "2026-08-16T10:00:00Z"
        ),

        // MARK: user_003 (Lê Hoàng Nam) — 1 video
        Story(
            id: "story_003_a",
            authorId: "user_003",
            mediaKind: .video,
            mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            thumbnailURL: "https://picsum.photos/seed/nam1/216/384",
            width: 1080,
            height: 1920,
            durationSeconds: 8,
            mutedByDefault: false,
            caption: nil,
            textColorHex: nil,
            backgroundColorHex: nil,
            fontName: nil,
            stickers: [],
            mentions: [],
            placeId: nil,
            postRefId: nil,
            musicTrackId: nil,
            privacy: .closeFriends,
            allowReplies: true,
            allowReactions: true,
            isArchived: false,
            viewCount: 19,
            viewedByMe: false,
            reactionCount: 2,
            reactedByMe: false,
            recentReactions: [],
            createdAt: "2026-08-15T11:15:00Z",
            expiresAt: "2026-08-16T11:15:00Z"
        )
    ]

    /// Returns all stories authored by the given user, ordered by `createdAt` ascending.
    static func mockStories(for userId: String) -> [Story] {
        mockData.filter { $0.authorId == userId }
    }

    /// Grouped mock: `[userId: [Story]]`. Handy for a Facebook-style story tray
    /// where each user shows as one entry with N stories inside.
    static let mockStoriesByUser: [String: [Story]] = Dictionary(
        grouping: mockData,
        by: { $0.authorId }
    )

    /// Sample audio tracks used to test in-story background music. Replace with
    /// real track URLs when integrating with a backend music service.
    static let mockMusicURLs: [String: String] = [
        "track_001": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "track_002": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"
    ]

    /// Convenience: resolve a `musicTrackId` on a story to a playable URL string.
    static func mockMusicURL(for musicTrackId: String?) -> String? {
        guard let musicTrackId else { return nil }
        return mockMusicURLs[musicTrackId]
    }
}
