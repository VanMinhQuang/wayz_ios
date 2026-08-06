//
//  CommentDTO.swift
//  wayz_ios
//

/// `PlaceCommentPublic` — not enumerated under "Shared Data Schemas" in the
/// doc, so this mirrors the `POST /places/{id}/comments` request body (§6.2)
/// plus identifiers/timestamp. `GET .../comments` (§6.1) returns a flat list;
/// `parentId` is what threads replies under their parent, there's no nested
/// `replies` array on the wire — `CommentMapper` builds the tree client-side.
struct CommentDTO: Codable {
    let id: String
    let placeId: String
    let userId: String
    let text: String
    let metaData: [String]
    let parentId: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case placeId  = "place_id"
        case userId   = "user_id"
        case text
        case metaData = "meta_data"
        case parentId = "parent_id"
        case createdAt = "created_at"
    }
}
