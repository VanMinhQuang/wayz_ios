//
//  PostDTO.swift
//  wayz_ios
//

/// `PostPublic` schema (doc §12).
struct PostDTO: Codable {
    let id: String
    let userId: String
    let imageURL: String
    let caption: String?
    let placeId: String?
    let likeCount: Int
    let likedByMe: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId    = "user_id"
        case imageURL  = "image_url"
        case caption
        case placeId   = "place_id"
        case likeCount = "like_count"
        case likedByMe = "liked_by_me"
        case createdAt = "created_at"
    }
}
