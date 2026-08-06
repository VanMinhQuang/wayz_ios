//
//  ConversationDTO.swift
//  wayz_ios
//

/// `ConversationPublic` — not enumerated under "Shared Data Schemas" in the
/// doc. Modeled on the fields a `GET /conversations` list needs to render a
/// DM inbox: the other participants, the last message for a preview, and
/// when it was last active.
struct ConversationDTO: Codable {
    let id: String
    let participantIds: [String]
    let lastMessage: MessagePublicDTO?
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case participantIds = "participant_ids"
        case lastMessage    = "last_message"
        case updatedAt      = "updated_at"
    }
}
