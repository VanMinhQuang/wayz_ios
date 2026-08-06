//
//  ConversationsRemoteDataSource.swift
//  wayz_ios
//

final class ConversationsRemoteDataSource {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchConversations() async throws -> [ConversationDTO] {
        try await client.request(.getConversations)
    }

    func fetchMessages(conversationId: String, limit: Int) async throws -> [MessagePublicDTO] {
        try await client.request(.getMessages(conversationId: conversationId, limit: limit))
    }

    func sendMessage(conversationId: String, body: String, postRefId: String?) async throws -> MessagePublicDTO {
        try await client.request(.sendMessage(conversationId: conversationId, body: body, postRefId: postRefId))
    }
}
