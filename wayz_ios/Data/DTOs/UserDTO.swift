//
//  UserDTO.swift
//  wayz_ios
//

struct UserDTO: Decodable {
    let id: String
    let fullName: String
    let email: String
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName  = "full_name"
        case email
        case avatarURL = "avatar_url"
    }
}
