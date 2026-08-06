//
//  UploadMapper.swift
//  wayz_ios
//

enum UploadMapper {
    static func toEntity(_ dto: PresignedUploadDTO) -> PresignedUpload {
        PresignedUpload(uploadURL: dto.uploadURL, key: dto.key, fields: dto.fields)
    }
}

enum SeedMapper {
    static func toEntity(_ dto: SeedResultDTO) -> SeedResult {
        SeedResult(
            message: dto.message,
            seededCounts: SeededCounts(
                users: dto.seededCounts.users,
                places: dto.seededCounts.places,
                reviews: dto.seededCounts.reviews,
                posts: dto.seededCounts.posts,
                follows: dto.seededCounts.follows,
                conversations: dto.seededCounts.conversations,
                messages: dto.seededCounts.messages
            ),
            sampleUsers: dto.sampleUsers.map {
                SampleUser(username: $0.username, email: $0.email, password: $0.password)
            }
        )
    }
}
