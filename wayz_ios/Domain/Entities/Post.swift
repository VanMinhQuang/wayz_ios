//
//  Post.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct Post: Identifiable {
    let id: String
    let userId: String
    let imageURL: String
    let caption: String?
    let placeId: String?
    let likeCount: Int
    let likedByMe: Bool
    let createdAt: String
}
