//
//  ReviewDTO.swift
//  wayz_ios
//

/// `ReviewPublic` — not enumerated under "Shared Data Schemas" in the doc,
/// so this mirrors the `POST /places/{id}/reviews` request body (§5.2) plus
/// the identifiers/timestamp any created-resource response would carry.
struct ReviewDTO: Codable {
    let id: String
    let placeId: String
    let userId: String
    let rating: Int
    let comment: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case placeId  = "place_id"
        case userId   = "user_id"
        case rating
        case comment
        case createdAt = "created_at"
    }
}
