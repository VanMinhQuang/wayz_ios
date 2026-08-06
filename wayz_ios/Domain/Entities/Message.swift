//
//  Message.swift
//  wayz_ios
//
//  Domain entity — pure Swift, no framework imports.
//

struct Message: Identifiable {
    let id: String
    let conversationId: String
    let senderId: String
    let body: String
    let postRefId: String?
    let createdAt: String
    let readAt: String?
}

struct Conversation: Identifiable {
    let id: String
    let participantIds: [String]
    let lastMessage: Message?
    let updatedAt: String
}
