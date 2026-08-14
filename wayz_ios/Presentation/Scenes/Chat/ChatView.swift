import SwiftUI

struct ChatView: View {

    @State private var viewModel: ChatViewModel

    @State private var draftText: String = ""
    @FocusState private var isInputFocused: Bool

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            messageList
            ChatInputBar(text: $draftText, isFocused: $isInputFocused, onSend: sendMessage)
        }.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .principal) {
                    ChatHeaderView(user: viewModel.userTo)
                }
            }
            .background(Color(.systemBackground))
    }
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                        MessageBubble(
                            message: message,
                            showAvatar: shouldShowAvatar(at: index)
                        )
                        .id(message.id)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
            .onAppear { scrollToBottom(proxy: proxy, animated: false) }
            .onChange(of: viewModel.messages.count) {
                scrollToBottom(proxy: proxy, animated: true)
            }
        }
    }
    
    private func sendMessage() {
        viewModel.sendMessage(draftText)
        draftText = ""
    }

    private func shouldShowAvatar(at index: Int) -> Bool {
        // Show avatar only on the last message of a consecutive run from the same sender
        guard index < viewModel.messages.count - 1 else { return true }
        return viewModel.messages[index].chatFrom.id != viewModel.messages[index + 1].chatFrom.id
    }
 
    
    
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool) {
        guard let lastId = viewModel.messages.last?.id else { return }
        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(lastId, anchor: .bottom)
        }
    }
}



#Preview {
    NavigationStack {
        ChatView(viewModel: ChatViewModel())
    }
    .environment(AppRouter())
}
