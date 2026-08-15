//
//  ConversationsRepositoryProtocol.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

protocol ConversationsRepositoryProtocol {
    func fetchConversations() async throws -> [Conversation]

    /// Returns the existing 1-1 conversation with `userId` if any, otherwise
    /// creates it. Backend returns 403 if either party has blocked the other.
    func startConversation(userId: String) async throws -> Conversation

    func fetchMessages(conversationId: String, limit: Int) async throws -> [Message]
    func sendMessage(conversationId: String, body: String) async throws -> Message
}
