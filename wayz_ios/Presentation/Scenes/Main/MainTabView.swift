//
//  MainTabView.swift
//  wayz_ios
//

import SwiftUI

enum AppTab: Int {
    case map     = 0
    case social  = 1
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

            SocialTabView()
                .tabItem {
                    Label("Social", systemImage: selectedTab == .social ? "photo.fill" : "photo")
                }
                .tag(AppTab.social)

            ProfileTabView(router: router)
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
                }
                .tag(AppTab.profile)
        }
        .tint(theme.colors.primary)
    }
}
