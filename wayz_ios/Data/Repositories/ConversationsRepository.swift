//
//  ConversationsRepository.swift
//  wayz_ios
//

final class ConversationsRepository: ConversationsRepositoryProtocol {
    private let remoteDataSource: ConversationsRemoteDataSource

    init(remoteDataSource: ConversationsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchConversations() async throws -> [Conversation] {
        try await remoteDataSource.fetchConversations().map(ConversationMapper.toEntity)
    }

    func fetchMessages(conversationId: String, limit: Int) async throws -> [Message] {
        try await remoteDataSource.fetchMessages(conversationId: conversationId, limit: limit).map(MessageMapper.toEntity)
    }

    func sendMessage(conversationId: String, body: String, postRefId: String?) async throws -> Message {
        let dto = try await remoteDataSource.sendMessage(conversationId: conversationId, body: body, postRefId: postRefId)
        return MessageMapper.toEntity(dto)
    }
}
