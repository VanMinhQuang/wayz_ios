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

    func startConversation(userId: String) async throws -> Conversation {
        let dto = try await remoteDataSource.startConversation(userId: userId)
        return ConversationMapper.toEntity(dto)
    }

    func fetchMessages(conversationId: String, limit: Int) async throws -> [Message] {
        try await remoteDataSource.fetchMessages(conversationId: conversationId, limit: limit).map(MessageMapper.toEntity)
    }

    func sendMessage(conversationId: String, body: String) async throws -> Message {
        let dto = try await remoteDataSource.sendMessage(conversationId: conversationId, body: body)
        return MessageMapper.toEntity(dto)
    }
}
