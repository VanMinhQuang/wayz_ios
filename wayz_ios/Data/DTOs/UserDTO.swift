//
//  UserDTO.swift
//  wayz_ios
//

/// `UserMe` schema (doc §2.1/§2.2, also the `201` response of `POST /auth/register`).
/// Includes `email`, unlike `UserPublicDTO` which is safe to show to other users.
struct UserDTO: Codable {
    let id: String
    let username: String
    let email: String
    let fullName: String?
    let bio: String?
    let avatarURL: String?
    let isPrivate: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case fullName  = "full_name"
        case bio
        case avatarURL = "avatar_url"
        case isPrivate = "is_private"
        case createdAt = "created_at"
    }
}
