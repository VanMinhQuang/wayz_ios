// MARK: - Mock UserChat

extension UserChat {
    static let mockUsers: [UserChat] = [
        UserChat(
            id: "user_001",
            name: "Nguyễn Văn Minh Quang",
            avatar: "avatar_quang",
            hasNewChat: true,
            lastMessage: "Ok anh gửi file báo cáo nhé",
            hasStory: true
        ),
        UserChat(
            id: "user_002",
            name: "Trần Thị Lan",
            avatar: "avatar_lan",
            hasNewChat: false,
            lastMessage: "Mai họp lúc mấy giờ vậy?",
            hasStory: true
        ),
        UserChat(
            id: "user_003",
            name: "Lê Hoàng Nam",
            avatar: "avatar_nam",
            hasNewChat: true,
            lastMessage: "Đã fix xong bug rồi nha",
            hasStory: true
        ),
        UserChat(
            id: "user_004",
            name: "Phạm Thu Hà",
            avatar: "avatar_ha",
            hasNewChat: false,
            lastMessage: "Cảm ơn anh nhiều!",
            hasStory: false
        )
    ]

    static let mockCurrentUser = UserChat(
        id: "user_me",
        name: "Tôi",
        avatar: "avatar_me",
        hasNewChat: false,
        lastMessage: "",
        hasStory: true,
        isMe: true
    )

    /// Look up mock user by id — used to resolve a `Story.authorId`
    /// back to its owner for display (avatar, name, etc.).
    static func mockUser(forId id: String) -> UserChat? {
        if mockCurrentUser.id == id { return mockCurrentUser }
        return mockUsers.first { $0.id == id }
    }
}

// MARK: - Mock ChatContent

extension ChatContent {
    /// One-on-one conversation between `mockCurrentUser` (me) and `mockUsers[0]`.
    static let mockMessages: [ChatContent] = [
        ChatContent(
            id: "msg_001",
            message: "Chào anh, dạo này công việc thế nào rồi?",
            chatFrom: UserChat.mockUsers[0],
            createdAt: "09:12"
        ),
        ChatContent(
            id: "msg_002",
            message: "Ổn em ơi, đang setup CI/CD cho con server mới",
            chatFrom: UserChat.mockCurrentUser,
            createdAt: "09:13"
        ),
        ChatContent(
            id: "msg_003",
            message: "Wow nghe hay nhỉ, khi nào xong cho em xem với",
            chatFrom: UserChat.mockUsers[0],
            createdAt: "09:14"
        ),
        ChatContent(
            id: "msg_004",
            message: "Ok anh gửi file báo cáo nhé",
            chatFrom: UserChat.mockCurrentUser,
            createdAt: "09:15"
        ),
        ChatContent(
            id: "msg_005",
            message: "Cảm ơn anh nhiều!",
            chatFrom: UserChat.mockUsers[0],
            createdAt: "09:16"
        )
    ]
}
