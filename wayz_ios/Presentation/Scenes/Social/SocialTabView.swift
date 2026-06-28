//
//  SocialTabView.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Models

struct Moment: Identifiable {
    let id = UUID()
    let friendName: String
    let friendInitial: String
    let avatarColor: Color
    let momentColor: Color
    let emoji: String
    let timeAgo: String
    let caption: String?
    var isSeen: Bool = false
}

// MARK: - View

struct SocialTabView: View {
    @State private var moments: [Moment] = Moment.samples
    @State private var sentReaction: String? = nil

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            // MARK: TikTok-style vertical paged feed
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(moments) { moment in
                        MomentPageView(moment: moment)
                            .containerRelativeFrame(.vertical)
                            .scrollTransition(.animated(.spring(response: 0.35, dampingFraction: 0.85))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.92)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()

            // MARK: Floating top bar
            topBar
                .padding(.top, 8)
                .background(
                    LinearGradient(
                        colors: [.black.opacity(0.5), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    .ignoresSafeArea()
                )
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "tray.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Text("wayz")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Button(action: {}) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

// MARK: - Single moment full-screen page

private struct MomentPageView: View {
    let moment: Moment
    @State private var sentReaction: String? = nil

    var body: some View {
        ZStack {
            // Subtle background tint
            moment.momentColor.opacity(0.12).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Large widget
                widget
                    .padding(.bottom, 24)

                // Caption
                if let caption = moment.caption {
                    Text(caption)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 24)
                }

                // Reaction strip
                reactionStrip
                    .padding(.bottom, 40)

                // Camera button
                cameraButton
                    .padding(.bottom, 32)
            }
            .padding(.top, 80) // clear floating top bar
        }
    }

    // MARK: Widget

    private var widget: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 44)
                .fill(moment.momentColor.gradient)
                .frame(width: 300, height: 300)
                .shadow(color: moment.momentColor.opacity(0.6), radius: 40, x: 0, y: 12)

            if let reaction = sentReaction {
                Text(reaction)
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(moment.emoji)
                    .font(.system(size: 110))
                    .transition(.opacity)
            }

            // Name + time pills
            VStack {
                Spacer()
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(moment.avatarColor)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text(moment.friendInitial)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                        Text(moment.friendName.components(separatedBy: " ").first ?? "")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.35), in: Capsule())

                    Spacer()

                    Text(moment.timeAgo)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.35), in: Capsule())
                }
                .padding(14)
            }
            .frame(width: 300, height: 300)
        }
    }

    // MARK: Reactions

    private var reactionStrip: some View {
        HStack(spacing: 14) {
            ForEach(["❤️", "😂", "🔥", "😮", "👏"], id: \.self) { emoji in
                Button(action: { sendReaction(emoji) }) {
                    Text(emoji)
                        .font(.system(size: 26))
                        .padding(10)
                        .background(
                            Circle().fill(
                                sentReaction == emoji
                                    ? Color.white.opacity(0.25)
                                    : Color.white.opacity(0.08)
                            )
                        )
                        .scaleEffect(sentReaction == emoji ? 1.2 : 1)
                        .animation(.spring(response: 0.25), value: sentReaction)
                }
            }
        }
    }

    // MARK: Camera button

    private var cameraButton: some View {
        Button(action: {}) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 3)
                    .frame(width: 80, height: 80)
                Circle()
                    .fill(.white)
                    .frame(width: 66, height: 66)
                Image(systemName: "camera.fill")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }

    private func sendReaction(_ emoji: String) {
        withAnimation(.spring(response: 0.3)) { sentReaction = emoji }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { sentReaction = nil }
        }
    }
}

// MARK: - Sample data

extension Moment {
    static let samples: [Moment] = [
        Moment(friendName: "Alice Nguyen", friendInitial: "A",
               avatarColor: .pink, momentColor: .pink,
               emoji: "🌸", timeAgo: "2m ago",
               caption: "Good morning! ☀️"),
        Moment(friendName: "Bob Tran", friendInitial: "B",
               avatarColor: .orange, momentColor: .orange,
               emoji: "🍜", timeAgo: "15m ago",
               caption: "Lunch time 🍜", isSeen: true),
        Moment(friendName: "Minh Le", friendInitial: "M",
               avatarColor: .purple, momentColor: .purple,
               emoji: "🎵", timeAgo: "1h ago",
               caption: nil, isSeen: true),
        Moment(friendName: "Linh Pham", friendInitial: "L",
               avatarColor: .teal, momentColor: .teal,
               emoji: "🌊", timeAgo: "2h ago",
               caption: "Beach day 🏖️"),
        Moment(friendName: "Huy Vo", friendInitial: "H",
               avatarColor: .green, momentColor: .green,
               emoji: "⚽", timeAgo: "3h ago",
               caption: nil, isSeen: true)
    ]
}

#Preview {
    SocialTabView()
}
