//
//  SocialTabView.swift
//  wayz_ios
//

import SwiftUI
import EmojiKit



// MARK: - View

struct SocialTabView: View {
    @State private var viewModel: SocialTabViewModel

    init(viewModel: SocialTabViewModel = SocialTabViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack{
            
            // MARK: Floating top bar
            topBar
                .padding(.top, 8)
            
            
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()

                // MARK: TikTok-style vertical paged feed
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.moments) { moment in
                            MomentPageView(viewModel: MomentPageViewModel(moment: moment))
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

            }
            .preferredColorScheme(.dark)
        }

    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            // Profile avatar
            Button(action: {}) {
                Circle()
                    .fill(
                        LinearGradient(colors: [.pink, .purple],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 38, height: 38)
                    .overlay(
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                    .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 1))
            }

            Spacer()

            // "Everyone" audience picker
            Menu {
                Button("Everyone") {}
                Button("Close Friends") {}
            } label: {
                HStack(spacing: 6) {
                    Text("Everyone")
                        .font(.system(size: 16, weight: .bold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.white.opacity(0.16), in: Capsule())
            }

            Spacer()

            // Chat / activity button
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(.white.opacity(0.16))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        )

                    Text("1")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                        .background(Color.orange, in: Circle())
                        .offset(x: 4, y: -4)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

// MARK: - Single moment full-screen page

private struct MomentPageView: View {
    @State var viewModel: MomentPageViewModel
    @State private var showReactionSheet = false

    private var moment: Moment { viewModel.moment }

    var body: some View {
        VStack(spacing: 0) {
            // Photo card — flexible, fills whatever space is left after the
            // fixed-size rows below it, so it can never overflow the page.
            photoCard
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .frame(maxHeight: .infinity)

            // Sender + time
            HStack(spacing: 6) {
                Text(moment.friendName.components(separatedBy: " ").first ?? "")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Text(moment.timeAgo)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.45))
            }
            .padding(.top, 16)
            .fixedSize(horizontal: false, vertical: true)

            // Send-a-message bar
            messageBar
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .fixedSize(horizontal: false, vertical: true)

            // Bottom toolbar
            bottomToolbar
                .padding(.top, 16)
                .padding(.bottom, 16)
                .fixedSize(horizontal: false, vertical: true)
        }
        .sheet(isPresented: $showReactionSheet) {
            ReactionPickerSheet { emoji in
                showReactionSheet = false
                viewModel.sendReaction(emoji)
            }
            .presentationDetents([.height(320)])
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
            .preferredColorScheme(.dark)
        }
    }

    // MARK: Photo card

    private var photoCard: some View {
        ZStack {
            AppImage(url: moment.imageURL, cornerRadius: 40, width: UIScreen.width * 0.95, height: UIScreen.height * 0.4)
                // Never let the photo itself animate/shift — reactions animate on their own overlay.
                .transaction { $0.animation = nil }
                .onTapGesture(count: 2) {
                    viewModel.sendReaction("❤️")
                }

            // Sent reaction bubble — animates in AND out at the center of the photo,
            // same scale + opacity transition as the original widget reaction.
            if let reaction = viewModel.sentReaction {
                ZStack {
                    reactionBubble(reaction)
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.3, dampingFraction: 0.55), value: viewModel.sentReaction)
            }
        }
    }

    /// A single emoji renders large and centered (matching the original design);
    /// free-form text renders as a quoted pill.
    @ViewBuilder
    private func reactionBubble(_ reaction: String) -> some View {
        if reaction.count <= 2 {
            Text(reaction)
                .font(.system(size: 80))
        } else {
            HStack(spacing: 6) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                Text(reaction)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.6), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 1))
            .padding(.horizontal, 40)
        }
    }

    // MARK: Message bar

    @FocusState private var isMessageFieldFocused: Bool

    private var messageBar: some View {
        HStack(spacing: 10) {
            TextField(
                "",
                text: $viewModel.messageText,
                prompt: Text("Send message...").foregroundStyle(.white.opacity(0.45))
            )
            .focused($isMessageFieldFocused)
            .foregroundStyle(.white)
            .font(.system(size: 15))
            .submitLabel(.send)
            .onSubmit { viewModel.sendMessage() }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white.opacity(0.1), in: Capsule())

            Button {
                if viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showReactionSheet = true
                } else {
                    viewModel.sendMessage()
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.1), in: Circle())
            }
        }
    }

    // MARK: Bottom toolbar

    private var bottomToolbar: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Button(action: {}) {
                ZStack {
                    Circle()
                        .stroke(Color.yellow, lineWidth: 4)
                        .frame(width: 76, height: 76)
                    Circle()
                        .fill(.white)
                        .frame(width: 64, height: 64)
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 36)
    }
}

// MARK: - Reaction picker bottom sheet

/// A full, categorized emoji keyboard powered by EmojiKit (https://github.com/danielsaidi/EmojiKit),
/// used here instead of a hand-rolled fixed emoji list so people can react with any emoji.
private struct ReactionPickerSheet: View {
    let onSelect: (String) -> Void

    @State private var category: EmojiCategory?
    @State private var selection: Emoji.GridSelection?

    var body: some View {
        VStack(spacing: 12) {
            Text("Send a reaction")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 12)

            GeometryReader { geo in
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        EmojiGrid(
                            category: $category,
                            selection: $selection,
                            geometryProxy: geo,
                            scrollViewProxy: scrollProxy,
                            action: { emoji in onSelect(emoji.char) },
                            sectionTitle: { params in
                                Text(params.category.localizedName)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            },
                            gridItem: { params in
                                Text(params.emoji.char)
                                    .font(.system(size: 30))
                                    .frame(width: 48, height: 48)
                            }
                        )
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
}



#Preview {
    SocialTabView()
}
