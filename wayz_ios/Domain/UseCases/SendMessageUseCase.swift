//
//  SendMessageUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class SendMessageUseCase {
    private let repository: ConversationsRepositoryProtocol

    init(repository: ConversationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(conversationId: String, body: String, postRefId: String? = nil) async throws -> Message {
        try await repository.sendMessage(conversationId: conversationId, body: body, postRefId: postRefId)
    }
}
