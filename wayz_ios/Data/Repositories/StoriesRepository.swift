//
//  StoriesRepository.swift
//  wayz_ios
//

final class StoriesRepository: StoriesRepositoryProtocol {
    private let remoteDataSource: StoriesRemoteDataSource

    init(remoteDataSource: StoriesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func createStory(
        type: StoryType,
        textContent: String?,
        mediaURL: String?,
        background: String?,
        musicURL: String?
    ) async throws -> Story {
        var body: [String: Any] = ["type": type.rawValue]
        if let textContent { body["text_content"] = textContent }
        if let mediaURL    { body["media_url"] = mediaURL }
        if let background  { body["background"] = background }
        if let musicURL    { body["music_url"] = musicURL }
        let dto = try await remoteDataSource.createStory(body: body)
        return StoryMapper.toEntity(dto)
    }

    func deleteStory(storyId: String) async throws {
        try await remoteDataSource.deleteStory(storyId: storyId)
    }

    func fetchTray() async throws -> [StoryTrayUser] {
        try await remoteDataSource.fetchTray().map(StoryTrayMapper.toEntity)
    }

    func fetchUserStories(userId: String) async throws -> [Story] {
        try await remoteDataSource.fetchUserStories(userId: userId).map(StoryMapper.toEntity)
    }

    func markStoryViewed(storyId: String) async throws {
        try await remoteDataSource.markViewed(storyId: storyId)
    }

    func fetchStoryViewers(storyId: String) async throws -> [StoryViewer] {
        try await remoteDataSource.fetchViewers(storyId: storyId).map(StoryViewerMapper.toEntity)
    }
}
