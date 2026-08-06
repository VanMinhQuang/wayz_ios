//
//  GetMessagesUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetMessagesUseCase {
    private let repository: ConversationsRepositoryProtocol

    init(repository: ConversationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(conversationId: String, limit: Int = 50) async throws -> [Message] {
        try await repository.fetchMessages(conversationId: conversationId, limit: limit)
    }
}
