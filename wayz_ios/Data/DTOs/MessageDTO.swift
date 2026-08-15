//
//  MessageDTO.swift
//  wayz_ios
//

/// `MessagePublic` schema (doc §12) — the shape of both DM send/list
/// responses and the payload pushed over `WS /ws/messages`.
struct MessagePublicDTO: Codable {
    let id: String
    let conversationId: String
    let senderId: String
    let body: String
    let createdAt: String
    let readAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case senderId       = "sender_id"
        case body
        case createdAt      = "created_at"
        case readAt         = "read_at"
    }
}
