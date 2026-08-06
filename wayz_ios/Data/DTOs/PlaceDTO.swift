//
//  PlaceDTO.swift
//  wayz_ios
//

/// `PlacePublic` schema (doc §12).
struct PlaceDTO: Codable {
    let id: String
    let name: String
    let description: String?
    let detail: String?
    let address: String?
    let category: String?
    let tags: [String]
    let latitude: Double
    let longitude: Double
    let images: [PlaceImageDTO]
    let avgRating: Double
    let reviewCount: Int
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case detail
        case address
        case category
        case tags
        case latitude
        case longitude
        case images
        case avgRating   = "avg_rating"
        case reviewCount = "review_count"
        case createdAt   = "created_at"
    }
}

/// One entry of `PlacePublic.images` — a plain `{url, order}` pair, distinct
/// from the richer media objects returned by `GET /places/{id}/images`.
struct PlaceImageDTO: Codable {
    let url: String
    let order: Int
}
