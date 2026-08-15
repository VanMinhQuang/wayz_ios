//
//  ConversationDTO.swift
//  wayz_ios
//

/// `ConversationPublic` schema (doc §12).
struct ConversationDTO: Codable {
    let id: String
    let participantIds: [String]
    let lastMessageAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case participantIds = "participant_ids"
        case lastMessageAt  = "last_message_at"
    }
}
