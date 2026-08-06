//
//  User.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct User {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?

    // Fields present on the real `UserMe`/`UserPublic` API schemas.
    let username: String
    let bio: String?
    let isPrivate: Bool
    let createdAt: String?

    init(
        id: String,
        name: String,
        email: String,
        avatarURL: String? = nil,
        username: String = "",
        bio: String? = nil,
        isPrivate: Bool = false,
        createdAt: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.username = username
        self.bio = bio
        self.isPrivate = isPrivate
        self.createdAt = createdAt
    }
}
