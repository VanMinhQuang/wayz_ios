//
//  UserPublicDTO.swift
//  wayz_ios
//

/// `UserPublic` schema (doc §12) — the safe-to-share subset of a profile,
/// returned by follow lists and `GET /users/{username}`. No `email`.
struct UserPublicDTO: Codable {
    let id: String
    let username: String
    let fullName: String?
    let bio: String?
    let avatarURL: String?
    let isPrivate: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName  = "full_name"
        case bio
        case avatarURL = "avatar_url"
        case isPrivate = "is_private"
        case createdAt = "created_at"
    }
}
