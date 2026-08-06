//
//  ProfileTabView.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Models

struct ProfilePostTile: Identifiable {
    let id = UUID()
    let color: Color
    let emoji: String
    let likes: Int
    let comments: Int
}

struct StoryHighlight: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let color: Color
}

// MARK: - View

struct ProfileTabView: View {
    @Environment(\.appTheme) private var theme
    let router: AppRouter

    @State private var selectedTab: ProfileContentTab = .posts
    @State private var showLogoutDialog = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    profileHeader
                    highlightsRow
                    contentTabBar
                    postsGrid
                }
            }
            .background(theme.colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("quang.van")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(theme.colors.textPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "plus.app")
                                .font(.system(size: 20))
                                .foregroundStyle(theme.colors.textPrimary)
                        }
                        Button(action: { showLogoutDialog = true }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 20))
                                .foregroundStyle(theme.colors.textPrimary)
                        }
                    }
                }
            }
            .appDialog(isPresented: $showLogoutDialog) {
                AppDialog(
                    title: "Log Out",
                    message: "Are you sure you want to log out?",
                    icon: "arrow.right.square.fill",
                    iconColor: .red,
                    actions: [
                        .destructive("Log Out") { router.logOut() },
                        .ghost("Cancel") { showLogoutDialog = false }
                    ]
                )
            }
        }
    }

    // MARK: - Profile header

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 24) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 84, height: 84)
                    Text("Q")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                }

                // Stats
                HStack(spacing: 0) {
                    statView(count: "\(ProfilePostTile.samples.count)", label: "Posts")
                    statView(count: "248", label: "Followers")
                    statView(count: "183", label: "Following")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)

            // Name + bio
            VStack(alignment: .leading, spacing: 4) {
                Text("Quang Van")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(theme.colors.textPrimary)

                Text("iOS Developer 📱")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.colors.textPrimary)

                Text("Building Wayz 🗺️ • Ho Chi Minh City")
                    .font(.system(size: 14))
                    .foregroundStyle(theme.colors.textSecondary)

                Link("wayz.com", destination: URL(string: "https://wayz.com")!)
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal, 16)

            // Action buttons
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(theme.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: {}) {
                    Text("Share Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(theme.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: {}) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(theme.colors.textPrimary)
                        .frame(width: 36, height: 32)
                        .background(theme.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }

    private func statView(count: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(count)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(theme.colors.textPrimary)
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Highlights

    private var highlightsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Add new
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .stroke(Color(UIColor.separator), lineWidth: 1)
                            .frame(width: 64, height: 64)
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundStyle(theme.colors.textPrimary)
                    }
                    Text("New")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)
                }

                ForEach(StoryHighlight.samples) { highlight in
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(highlight.color.opacity(0.15))
                                .frame(width: 64, height: 64)
                            Text(highlight.emoji)
                                .font(.system(size: 28))
                        }
                        Text(highlight.title)
                            .font(.system(size: 12))
                            .foregroundStyle(theme.colors.textPrimary)
                            .lineLimit(1)
                    }
                    .frame(width: 72)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Content tab bar

    enum ProfileContentTab {
        case posts, reels, tagged
    }

    private var contentTabBar: some View {
        HStack(spacing: 0) {
            tabBarItem(icon: "square.grid.3x3.fill", tab: .posts)
            tabBarItem(icon: "play.square.fill", tab: .reels)
            tabBarItem(icon: "person.crop.square", tab: .tagged)
        }
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private func tabBarItem(icon: String, tab: ProfileContentTab) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(selectedTab == tab ? theme.colors.textPrimary : theme.colors.textSecondary)
                    .frame(height: 44)

                Rectangle()
                    .fill(selectedTab == tab ? theme.colors.textPrimary : .clear)
                    .frame(height: 1)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Posts grid

    private var postsGrid: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(ProfilePostTile.samples) { post in
                ZStack {
                    Rectangle()
                        .fill(post.color.gradient)
                        .aspectRatio(1, contentMode: .fit)

                    Text(post.emoji)
                        .font(.system(size: 36))

                    // Overlay on press (likes)
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            Label("\(post.likes)", systemImage: "heart.fill")
                            Label("\(post.comments)", systemImage: "bubble.right.fill")
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.bottom, 6)
                    }
                }
            }
        }
    }
}

// MARK: - Sample data

extension ProfilePostTile {
    static let samples: [ProfilePostTile] = [
        ProfilePostTile(color: .blue,   emoji: "🗺️",  likes: 124, comments: 8),
        ProfilePostTile(color: .pink,   emoji: "🌸",  likes: 89,  comments: 12),
        ProfilePostTile(color: .orange, emoji: "🍜",  likes: 201, comments: 24),
        ProfilePostTile(color: .green,  emoji: "🌿",  likes: 67,  comments: 5),
        ProfilePostTile(color: .purple, emoji: "🎵",  likes: 143, comments: 18),
        ProfilePostTile(color: .teal,   emoji: "🌊",  likes: 312, comments: 41),
        ProfilePostTile(color: .red,    emoji: "❤️",  likes: 523, comments: 67),
        ProfilePostTile(color: .yellow, emoji: "☀️",  likes: 98,  comments: 9),
        ProfilePostTile(color: .indigo, emoji: "🌙",  likes: 176, comments: 22),
        ProfilePostTile(color: .mint,   emoji: "🍃",  likes: 88,  comments: 7),
        ProfilePostTile(color: .cyan,   emoji: "💧",  likes: 134, comments: 15),
        ProfilePostTile(color: .brown,  emoji: "☕",  likes: 245, comments: 33)
    ]
}

extension StoryHighlight {
    static let samples: [StoryHighlight] = [
        StoryHighlight(title: "Travel",  emoji: "✈️",  color: .blue),
        StoryHighlight(title: "Food",    emoji: "🍜",  color: .orange),
        StoryHighlight(title: "Work",    emoji: "💻",  color: .purple),
        StoryHighlight(title: "Friends", emoji: "👥",  color: .green),
        StoryHighlight(title: "Wayz",    emoji: "🗺️",  color: .teal)
    ]
}

#Preview {
    ProfileTabView(router: AppRouter())
        .theme(.default)
}
