//
//  UserMapper.swift
//  wayz_ios
//

enum UserMapper {
    static func toEntity(_ dto: UserDTO) -> User {
        User(
            id:        dto.id,
            name:      dto.fullName,
            email:     dto.email,
            avatarURL: dto.avatarURL
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
