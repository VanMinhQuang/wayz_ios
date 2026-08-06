//
//  UserMapper.swift
//  wayz_ios
//

enum UserMapper {
    static func toEntity(_ dto: UserDTO) -> User {
        User(
            id:        dto.id,
            name:      dto.fullName ?? dto.username,
            email:     dto.email,
            avatarURL: dto.avatarURL,
            username:  dto.username,
            bio:       dto.bio,
            isPrivate: dto.isPrivate,
            createdAt: dto.createdAt
        )
    }

    /// `UserPublic` carries no `email` — it's not safe to share with other users.
    static func toEntity(_ dto: UserPublicDTO) -> User {
        User(
            id:        dto.id,
            name:      dto.fullName ?? dto.username,
            email:     "",
            avatarURL: dto.avatarURL,
            username:  dto.username,
            bio:       dto.bio,
            isPrivate: dto.isPrivate,
            createdAt: dto.createdAt
        )
    }
}

enum TokenMapper {
    static func toEntity(_ dto: TokenDTO) -> AuthToken {
        AuthToken(
            accessToken:  dto.accessToken,
            refreshToken: dto.refreshToken
        )
    }
}
