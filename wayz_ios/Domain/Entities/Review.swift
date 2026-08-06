//
//  Review.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct Review: Identifiable {
    let id: String
    let placeId: String
    let userId: String
    let rating: Int
    let comment: String?
    let createdAt: String
}
