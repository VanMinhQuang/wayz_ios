//
//  MessageMapper.swift
//  wayz_ios
//

enum MessageMapper {
    static func toEntity(_ dto: MessagePublicDTO) -> Message {
        Message(
            id: dto.id,
            conversationId: dto.conversationId,
            senderId: dto.senderId,
            body: dto.body,
            createdAt: dto.createdAt,
            readAt: dto.readAt
        )
    }
}

enum ConversationMapper {
    static func toEntity(_ dto: ConversationDTO) -> Conversation {
        Conversation(
            id: dto.id,
            participantIds: dto.participantIds,
            lastMessageAt: dto.lastMessageAt
        )
    }
}
