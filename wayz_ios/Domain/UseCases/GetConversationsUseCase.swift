//
//  GetConversationsUseCase.swift
//  wayz_ios
//
//  Domain layer — no framework imports.
//

final class GetConversationsUseCase {
    private let repository: ConversationsRepositoryProtocol

    init(repository: ConversationsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Conversation] {
        try await repository.fetchConversations()
    }
}
