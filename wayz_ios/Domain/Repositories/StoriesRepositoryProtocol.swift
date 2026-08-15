//
//  StoriesRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol StoriesRepositoryProtocol {
    /// Create a story. `type` is `"text" | "image" | "video"`.
    /// - `textContent` required if `type == "text"` (max 500 chars).
    /// - `mediaURL` required if `type == "image"` or `"video"`.
    /// - `background` optional, text stories only.
    /// - `musicURL` optional, any type.
    func createStory(
        type: StoryType,
        textContent: String?,
        mediaURL: String?,
        background: String?,
        musicURL: String?
    ) async throws -> Story

    /// Delete one of the caller's own stories.
    func deleteStory(storyId: String) async throws

    /// Story tray — self + people the caller follows, sorted by most recent.
    func fetchTray() async throws -> [StoryTrayUser]

    /// One user's active stories, ordered oldest → newest.
    func fetchUserStories(userId: String) async throws -> [Story]

    /// Mark a story as viewed by the caller.
    func markStoryViewed(storyId: String) async throws

    /// List of viewers — only the story owner can call this.
    func fetchStoryViewers(storyId: String) async throws -> [StoryViewer]
}
