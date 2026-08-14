

import SwiftUI



struct MessageBubble: View {
    let message: ChatContent
    let showAvatar: Bool

    private var isMe: Bool { message.chatFrom.isMe }

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            if isMe { Spacer(minLength: 40) }

            if !isMe {
                if showAvatar {
                    AvatarView(urlString: message.chatFrom.avatar, size: 24)
                } else {
                    Color.clear.frame(width: 24, height: 24)
                }
            }

            VStack(alignment: isMe ? .trailing : .leading, spacing: 2) {
                Text(message.message)
                    .font(.system(size: 15))
                    .foregroundStyle(isMe ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isMe ? Color.accentColor : Color(.secondarySystemBackground))
                    )

                if showAvatar {
                    Text(message.createdAt)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
            }

            if !isMe { Spacer(minLength: 40) }
        }
    }
}


 struct ChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void
 
    var body: some View {
        HStack(spacing: 10) {
            TextField("Nhắn tin...", text: $text, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    Capsule().fill(Color(.secondarySystemBackground))
                )
                .focused(isFocused)
 
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(canSend ? Color.accentColor : Color(.tertiaryLabel))
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
 
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


 struct ChatHeaderView: View {
    let user: UserChat
 
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                AvatarView(urlString: user.avatar, size: 34)
 
                if user.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                }
            }
 
            VStack(alignment: .leading, spacing: 1) {
                Text(user.name)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
 
                Text(user.isOnline ? "Đang hoạt động" : "Ngoại tuyến")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }.layoutPriority(1)
        }
    }
}

#Preview{
    ChatHeaderView(user: UserChat.mockCurrentUser)
}

struct AvatarView: View {
    let urlString: String
    var size: CGFloat = 32
 
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            default:
                Circle().fill(Color(.tertiarySystemFill))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
