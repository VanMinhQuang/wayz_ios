//
//  SeedResultDTO.swift
//  wayz_ios
//

/// Response of `POST /seed` (doc §11.1), matching the documented example exactly.
struct SeedResultDTO: Codable {
    let message: String
    let seededCounts: SeededCountsDTO
    let sampleUsers: [SampleUserDTO]

    enum CodingKeys: String, CodingKey {
        case message
        case seededCounts = "seeded_counts"
        case sampleUsers  = "sample_users"
    }
}

struct SeededCountsDTO: Codable {
    let users: Int
    let places: Int
    let reviews: Int
    let posts: Int
    let follows: Int
    let conversations: Int
    let messages: Int
}

struct SampleUserDTO: Codable {
    let username: String
    let email: String
    let password: String
}
