//
//  ChatListView.swift
//  wayz_ios
//
//  Created by Macbook on 12/8/26.
//

import SwiftUI

struct ChatListView: View {
    @State private var viewModel: ChatListViewModel
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    init(viewModel: ChatListViewModel = ChatListViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        
        VStack{
            Text("Wayz Chat")
                .font(theme.fonts.heading1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
            
                    AppTextField(
                        label: "",
                        placeholder: "Tìm kiếm người ",
                        text: $viewModel.search,
                        leadingIcon: "magnifyingglass",
                        trailingIcon: viewModel.search.isEmpty
                            ? nil : "xmark.circle.fill",
                        submitLabel: .search,
                        onSubmit: {

                        }
                    )
                    .padding(.horizontal, 16)

                    UserStoryList(stories: viewModel.users)

                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredChats) { chat in
                            Button {
                                router.push(AppRoute.userChat(chatId: chat.id))
                            } label: {
                                ChatRowView(chat: chat)
                            }
                            .buttonStyle(.plain)

                            Divider()
                                .padding(.leading, 84)
                        }
                    }
                }
                .padding(.bottom, 12)
            }
            .scrollIndicators(.hidden)
            .background(theme.colors.background)
        }
     

    }
}

#Preview {
    ChatListView(viewModel: ChatListViewModel())
        .environment(AppRouter())
}
