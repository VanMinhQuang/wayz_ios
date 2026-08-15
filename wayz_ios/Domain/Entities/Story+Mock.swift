//
//  Story+Mock.swift
//  wayz_ios
//
//  Dummy stories linked to `UserChat.mockUsers` via `userId`.
//  Gate usage behind `AppConfig.current.isMockDataEnabled` where appropriate.
//

extension Story {
    /// All mock stories, ordered oldest → newest per user.
    static let mockData: [Story] = [
        // MARK: user_me (Tôi) — 1 text story with background music
        Story(
            id: "story_me_001",
            userId: "user_me",
            type: .text,
            mediaURL: nil,
            textContent: "Chào buổi sáng mọi người ☀️",
            background: "gradient_sunset",
            musicURL: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
            viewCount: 12,
            viewedByMe: true,
            createdAt: "2026-08-15T07:20:00Z",
            expiresAt: "2026-08-16T07:20:00Z"
        ),

        // MARK: user_001 (Nguyễn Văn Minh Quang) — image + video
        Story(
            id: "story_001_a",
            userId: "user_001",
            type: .image,
            mediaURL: "https://picsum.photos/seed/quang1/1080/1920",
            textContent: "Cà phê sáng ☕️",
            background: nil,
            musicURL: nil,
            viewCount: 128,
            viewedByMe: false,
            createdAt: "2026-08-15T08:00:00Z",
            expiresAt: "2026-08-16T08:00:00Z"
        ),
        Story(
            id: "story_001_b",
            userId: "user_001",
            type: .video,
            mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            textContent: "Chuyến đi cuối tuần 🏞️",
            background: nil,
            musicURL: nil,
            viewCount: 87,
            viewedByMe: false,
            createdAt: "2026-08-15T09:30:00Z",
            expiresAt: "2026-08-16T09:30:00Z"
        ),

        // MARK: user_002 (Trần Thị Lan) — 1 image with music
        Story(
            id: "story_002_a",
            userId: "user_002",
            type: .image,
            mediaURL: "https://picsum.photos/seed/lan1/1080/1920",
            textContent: "Chiều nay đẹp quá 🌅",
            background: nil,
            musicURL: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
            viewCount: 42,
            viewedByMe: true,
            createdAt: "2026-08-15T10:00:00Z",
            expiresAt: "2026-08-16T10:00:00Z"
        ),

        // MARK: user_003 (Lê Hoàng Nam) — 1 video
        Story(
            id: "story_003_a",
            userId: "user_003",
            type: .video,
            mediaURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            textContent: nil,
            background: nil,
            musicURL: nil,
            viewCount: 19,
            viewedByMe: false,
            createdAt: "2026-08-15T11:15:00Z",
            expiresAt: "2026-08-16T11:15:00Z"
        )
    ]

    /// Returns all stories authored by the given user, ordered by `createdAt` ascending.
    static func mockStories(for userId: String) -> [Story] {
        mockData.filter { $0.userId == userId }
    }

    /// Grouped mock: `[userId: [Story]]`. Handy for a Facebook-style story tray
    /// where each user shows as one entry with N stories inside.
    static let mockStoriesByUser: [String: [Story]] = Dictionary(
        grouping: mockData,
        by: { $0.userId }
    )
}
