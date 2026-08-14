//
//  MainTabView.swift
//  wayz_ios
//

import SwiftUI

enum AppTab: Int {
    case map     = 0
    case chat  = 1
    case profile = 2
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .map
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router

    var body: some View {
        TabView(selection: $selectedTab) {
            MapTabView(
                mapViewModel: DIContainer.shared.resolve(MapViewModel.self)
            )
                .tabItem {
                    Label("Map", systemImage: selectedTab == .map ? "map.fill" : "map")
                }
                .tag(AppTab.map)

            ChatListView(
                viewModel: DIContainer.shared.resolve(ChatListViewModel.self)
            )
                .tabItem {
                    Label("Chat", systemImage: selectedTab == .chat ? "message.fill" : "message")
                }
                .tag(AppTab.chat)

            ProfileTabView(router: router)
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
                }
                .tag(AppTab.profile)
        }
        .tint(theme.colors.primary)
    }
}
