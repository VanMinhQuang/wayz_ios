//
//  StoriesRemoteDataSource.swift
//  wayz_ios
//

final class StoriesRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func createStory(body: [String: Any]) async throws -> StoryPublicDTO {
        try await client.request(.createStory(body: body))
    }

    func deleteStory(storyId: String) async throws {
        try await client.requestVoid(.deleteStory(storyId: storyId))
    }

    func fetchTray() async throws -> [StoryTrayUserDTO] {
        try await client.request(.getStoryTray)
    }

    func fetchUserStories(userId: String) async throws -> [StoryPublicDTO] {
        try await client.request(.getUserStories(userId: userId))
    }

    func markViewed(storyId: String) async throws {
        try await client.requestVoid(.markStoryViewed(storyId: storyId))
    }

    func fetchViewers(storyId: String) async throws -> [StoryViewerPublicDTO] {
        try await client.request(.getStoryViewers(storyId: storyId))
    }
}
