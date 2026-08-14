//
//  UserChat.swift
//  wayz_ios
//
//  Created by Macbook on 12/8/26.
//

struct UserChat: Identifiable {
    let id: String
    let name: String
    let avatar: String
    let hasNewChat: Bool
    let lastMessage: String
    let hasStory: Bool
    let isMe: Bool
    let isOnline: Bool
    let unReadCount: Int
    let time: String
    init(
        id: String = "",
        name: String = "",
        avatar: String = "",
        hasNewChat: Bool = false,
        lastMessage: String = "",
        hasStory: Bool = false,
        isMe: Bool = false,
        isOnline: Bool = false,
        unReadCount: Int = 0,
        time: String = ""
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.hasNewChat = hasNewChat
        self.lastMessage = lastMessage
        self.hasStory = hasStory
        self.isMe = isMe
        self.isOnline = isOnline
        self.unReadCount = unReadCount
        self.time = time
    }
}

struct ChatContent: Identifiable {
    let id: String
    let message: String
    let chatFrom: UserChat
    let createdAt: String
    let readAt: String?
    init(
        id: String = "",
        message: String = "",
        chatFrom: UserChat = UserChat(),
        createdAt: String = "",
        readAt: String = ""
    ) {
        self.id = id
        self.message = message
        self.chatFrom = chatFrom
        self.createdAt = createdAt
        self.readAt = readAt
    }
}
