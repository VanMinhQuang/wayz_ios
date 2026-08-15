import Foundation
import Observation

@Observable
final class ChatViewModel {
    let chatId: String
    var userTo: UserChat
    var messages: [ChatContent]

    init(chatId: String = UserChat.mockUsers[0].id) {
        self.chatId = chatId
        self.userTo = UserChat.mockUser(forId: chatId) ?? UserChat.mockUsers[0]
        self.messages = ChatContent.mockMessages
    }

    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newMessage = ChatContent(
            id: UUID().uuidString,
            message: trimmed,
            chatFrom: UserChat.mockCurrentUser,
            createdAt: Self.timestampFormatter.string(from: Date())
        )
        messages.append(newMessage)
    }

    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
