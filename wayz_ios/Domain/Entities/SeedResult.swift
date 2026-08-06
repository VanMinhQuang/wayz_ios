//
//  SeedResult.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct SeedResult {
    let message: String
    let seededCounts: SeededCounts
    let sampleUsers: [SampleUser]
}

struct SeededCounts {
    let users: Int
    let places: Int
    let reviews: Int
    let posts: Int
    let follows: Int
    let conversations: Int
    let messages: Int
}

struct SampleUser {
    let username: String
    let email: String
    let password: String
}
