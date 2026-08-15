//
//  UserStoryView.swift
//  wayz_ios
//
//  Facebook-style full-screen story viewer.
//   • text stories → gradient background + centered caption
//   • image stories → full-bleed AsyncImage
//   • video stories → AVPlayer inline with sound
//   • optional background music (musicTrackId → mockMusicURL) for image/text
//   • tap left/right → prev/next story
//   • horizontal PageView swipe (TabView.page) → prev/next user bundle
//   • long press → pause; auto-advance after story.durationSeconds
//   • all bundles exhausted → view dismisses itself
//

import AVFoundation
import AVKit
import SwiftUI

struct UserStoryView: View {
    @State private var viewModel: UserStoryViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.appTheme) private var theme

    // Media state — only the active bundle owns these
    @State private var videoPlayer: AVPlayer?
    @State private var audioPlayer: AVAudioPlayer?

    // Progress & interaction
    @State private var progress: Double = 0
    @State private var isPaused: Bool = false
    @State private var progressTask: Task<Void, Never>?

    init(viewModel: UserStoryViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            // Story viewer is always visually dark (matches Facebook/Instagram)
            // regardless of the app-wide color scheme. Use an explicit black
            // fill instead of `theme.colors.background` so the app doesn't
            // switch to dark mode for surrounding chrome.
            Color.black.ignoresSafeArea()

            if viewModel.status.isLoading {
                ProgressView().tint(.white)
            } else if let message = viewModel.status.errorMessage {
                Text(message).foregroundStyle(.white)
            } else if !viewModel.bundles.isEmpty {
                pager
            }
        }
        .ignoresSafeArea()
        .statusBarHidden()
        .task {
            await viewModel.load()
            configureAudioSession()
            setupCurrentStoryMedia()
            startProgress()
        }
        .onChange(of: viewModel.currentStoryIndex) { _, _ in
            resetForNewStory()
        }
        .onChange(of: viewModel.currentUserIndex) { _, _ in
            resetForNewStory()
        }
        .onChange(of: viewModel.didReachEnd) { _, ended in
            guard ended else { return }
            cleanup()
            // Defer the pop by one runloop tick so we don't mutate the
            // NavigationStack path while SwiftUI is still processing the
            // observable-state change that triggered this closure.
            DispatchQueue.main.async {
                router.pop()
            }
        }
        .onDisappear { cleanup() }
    }

    // MARK: - Pager (Facebook-style PageView between users)

    private var pager: some View {
        TabView(selection: userBinding) {
            ForEach(viewModel.bundles.indices, id: \.self) { bundleIdx in
                bundlePage(bundleIdx)
                    .tag(bundleIdx)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    /// Binding that drives the outer TabView. Setter routes through
    /// `jumpToUser` so we can also reset story index + trigger onChange logic.
    private var userBinding: Binding<Int> {
        Binding(
            get: { viewModel.currentUserIndex },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.jumpToUser(index: newValue)
                }
            }
        )
    }

    @ViewBuilder
    private func bundlePage(_ bundleIdx: Int) -> some View {
        let bundle = viewModel.bundles[bundleIdx]
        let isActive = bundleIdx == viewModel.currentUserIndex

        // Pick which story to render for this bundle:
        // - active bundle → whichever story the VM says is current
        // - inactive bundle → its first story (only visible during page transition)
        let story: Story = isActive
            ? (viewModel.currentStory ?? bundle.stories[0])
            : bundle.stories[0]

        ZStack {
            storyBackground(story, isActive: isActive)
            // Tap zones must sit BELOW the overlay so the X button in the
            // header stays clickable. Overlay VStack uses Spacers in the
            // middle which don't intercept taps, so taps still fall through
            // to the tap zones outside interactive header elements.
            if isActive { tapZones }
            storyOverlay(story, bundle: bundle, isActive: isActive)
        }
    }

    // MARK: - Background per media kind

    @ViewBuilder
    private func storyBackground(_ story: Story, isActive: Bool) -> some View {
        switch story.type {
        case .text:
            LinearGradient(
                colors: gradientColors(for: story),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .image:
            AsyncImage(url: URL(string: story.mediaURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Color.black
                default:
                    Color.black
                    ProgressView().tint(.white)
                }
            }

        case .video:
            if isActive, let player = videoPlayer {
                VideoPlayer(player: player).disabled(true)
            } else {
                // Placeholder for inactive bundle — avoid instantiating multiple AVPlayers.
                Color.black
            }
        }
    }

    // MARK: - Overlay (progress bars + header + caption)

    private func storyOverlay(_ story: Story, bundle: StoryBundle, isActive: Bool) -> some View {
        VStack(spacing: 0) {
            progressBars(for: bundle, isActive: isActive)
                .padding(.horizontal, 12)
                .padding(.top, 60)

            header(story, bundle: bundle)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            Spacer()

            if story.type == .text {
                centerText(story)
            }

            Spacer()

            if let caption = story.textContent, story.type != .text, !caption.isEmpty {
                Text(caption)
                    .font(theme.fonts.body)
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func progressBars(for bundle: StoryBundle, isActive: Bool) -> some View {
        HStack(spacing: 4) {
            ForEach(bundle.stories.indices, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 3)
                    .overlay(alignment: .leading) {
                        GeometryReader { geo in
                            Capsule()
                                .fill(theme.colors.primary)
                                .frame(width: geo.size.width * fillFraction(at: index, bundle: bundle, isActive: isActive))
                        }
                    }
            }
        }
    }

    private func fillFraction(at index: Int, bundle: StoryBundle, isActive: Bool) -> Double {
        guard isActive else { return 0 }
        if index < viewModel.currentStoryIndex { return 1 }
        if index > viewModel.currentStoryIndex { return 0 }
        return progress
    }

    private func header(_ story: Story, bundle: StoryBundle) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(theme.colors.primary.opacity(0.25))
                .frame(width: 36, height: 36)
                .overlay {
                    Text(String(bundle.author.name.prefix(1)))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(bundle.author.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text(relativeTime(from: story.createdAt))
                    .font(theme.fonts.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            if story.musicURL != nil {
                Image(systemName: "music.note")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(theme.colors.primary.opacity(0.4), in: Circle())
            }

            Button {
                cleanup()
                router.pop()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(8)
            }
        }
    }

    private func centerText(_ story: Story) -> some View {
        Text(story.textContent ?? "")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
    }

    // MARK: - Tap zones (prev/next story + long press pause)

    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { advanceStory(-1) }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { advanceStory(1) }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.15)
                .onChanged { _ in setPaused(true) }
                .onEnded { _ in setPaused(false) }
        )
    }

    // MARK: - Playback control

    private func advanceStory(_ direction: Int) {
        if direction < 0 {
            if viewModel.canGoPrevious {
                viewModel.previous()
            } else {
                progress = 0
                startProgress()
            }
        } else {
            viewModel.next()
        }
    }

    private func setPaused(_ paused: Bool) {
        isPaused = paused
        if paused {
            videoPlayer?.pause()
            audioPlayer?.pause()
        } else {
            videoPlayer?.play()
            audioPlayer?.play()
        }
    }

    private func resetForNewStory() {
        stopMedia()
        setupCurrentStoryMedia()
        progress = 0
        startProgress()
    }

    // MARK: - Media setup

    private func setupCurrentStoryMedia() {
        guard let story = viewModel.currentStory else { return }

        if story.type == .video, let urlString = story.mediaURL, let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            player.isMuted = false
            player.play()
            videoPlayer = player
        }

        // Background music for text/image stories (video's own audio track is used for video).
        if story.type != .video,
           let musicURLString = story.musicURL,
           let url = URL(string: musicURLString) {
            Task {
                await loadAudio(url: url, muted: false)
            }
        }
    }

    private func loadAudio(url: URL, muted: Bool) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let player = try AVAudioPlayer(data: data)
            player.numberOfLoops = -1
            player.volume = muted ? 0 : 1
            player.prepareToPlay()
            player.play()
            await MainActor.run {
                self.audioPlayer = player
            }
        } catch {
            #if DEBUG
            print("Failed to load audio: \(error)")
            #endif
        }
    }

    private func stopMedia() {
        videoPlayer?.pause()
        videoPlayer = nil
        audioPlayer?.stop()
        audioPlayer = nil
    }

    private func cleanup() {
        progressTask?.cancel()
        progressTask = nil
        stopMedia()
    }

    private func configureAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // MARK: - Progress timer (auto-advance)

    private func startProgress() {
        progressTask?.cancel()
        guard let story = viewModel.currentStory else { return }
        // Default display duration — video stories overrun this until the
        // clip finishes; text/image use the fixed 5s.
        let duration: Double = (story.type == .video) ? 12 : 5
        let ticks = 60

        progressTask = Task { @MainActor in
            for tick in 1...ticks {
                let step: UInt64 = UInt64((duration / Double(ticks)) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: step)
                if Task.isCancelled { return }
                while isPaused {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    if Task.isCancelled { return }
                }
                progress = Double(tick) / Double(ticks)
            }
            if !Task.isCancelled {
                advanceStory(1)
            }
        }
    }

    // MARK: - Styling helpers

    private func gradientColors(for story: Story) -> [Color] {
        // Backend's `background` field is a preset id (e.g. "gradient_sunset")
        // or a hex string ("#FF6B6B"). If it's a valid hex, derive from that;
        // otherwise fall back to a theme-based palette hashed by story id.
        if let hex = story.background, let base = color(fromHex: hex) {
            return [base, base.opacity(0.75), Color.black.opacity(0.4)]
        }
        // Theme-derived fallback palettes: primary/secondary/accent gradients.
        let palettes: [[Color]] = [
            [theme.colors.primary,   theme.colors.accent],
            [theme.colors.secondary, theme.colors.primary],
            [theme.colors.accent,    theme.colors.secondary],
            [theme.colors.primary,   theme.colors.info]
        ]
        return palettes[abs(story.id.hashValue) % palettes.count]
    }

    private func color(fromHex hex: String?) -> Color? {
        guard let hex else { return nil }
        var raw = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if raw.hasPrefix("#") { raw.removeFirst() }
        guard raw.count == 6, let value = UInt32(raw, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        return Color(red: r, green: g, blue: b)
    }

    private func relativeTime(from iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: iso) else { return iso }
        let diff = Date().timeIntervalSince(date)
        if diff < 60 { return "vừa xong" }
        if diff < 3600 { return "\(Int(diff / 60))p" }
        if diff < 86_400 { return "\(Int(diff / 3600))h" }
        return "\(Int(diff / 86_400))d"
    }
}

#Preview {
    UserStoryView(viewModel: UserStoryViewModel(authorId: "user_me"))
        .environment(AppRouter())
        .theme(.default)
}
