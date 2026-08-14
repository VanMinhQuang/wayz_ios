import Foundation
import Observation

@Observable
final class ChatViewModel {
    var userTo: UserChat
    var messages: [ChatContent]

    init(
        userTo: UserChat = UserChat.mockUsers[0],
        messages: [ChatContent] = ChatContent.mockMessages
    ) {
        self.userTo = userTo
        self.messages = messages
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
