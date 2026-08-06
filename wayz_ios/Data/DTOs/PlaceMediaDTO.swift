//
//  PlaceMediaDTO.swift
//  wayz_ios
//

/// Response entry of `GET /places/{place_id}/images` (doc §4.5) — richer than
/// `PlaceImageDTO`, since a place's gallery can include photos sourced from
/// comments as well as the place itself.
struct PlaceMediaDTO: Codable {
    let url: String
    let source: String
    let uploadedBy: String?
    let commentId: String?

    enum CodingKeys: String, CodingKey {
        case url
        case source
        case uploadedBy = "uploaded_by"
        case commentId  = "comment_id"
    }
}
