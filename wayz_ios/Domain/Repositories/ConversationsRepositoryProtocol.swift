//
//  ConversationsRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol ConversationsRepositoryProtocol {
    func fetchConversations() async throws -> [Conversation]
    func fetchMessages(conversationId: String, limit: Int) async throws -> [Message]
    func sendMessage(conversationId: String, body: String, postRefId: String?) async throws -> Message
}
