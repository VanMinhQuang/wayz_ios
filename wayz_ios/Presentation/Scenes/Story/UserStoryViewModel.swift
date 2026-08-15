//
//  UserStoryViewModel.swift
//  wayz_ios
//
//  Story viewer VM. Loads bundles for every author that has stories, then
//  navigates a 2D grid: users on the horizontal axis, that user's stories
//  on the vertical axis. `authorId` is the *starting* user; the viewer can
//  advance/rewind between users via swipes or after the last story of the
//  current user auto-advances.
//

import Foundation
import Observation

/// Scene-specific status. Wraps the shared `ScreenStatus` base cases and adds
/// playback states unique to a story viewer.
enum StoryScreenStatus: ScreenStatusRepresenting {
    case common(ScreenStatus)
    case playing
    case paused
    case buffering

    var base: ScreenStatus? {
        if case .common(let status) = self { return status }
        return nil
    }
    var isLoading: Bool { base?.isLoading == true || self == .buffering }
    var isLoaded: Bool  { base?.isLoaded  == true }
    var isFailed: Bool  { base?.isFailed  == true }
    var errorMessage: String? { base?.errorMessage }
}

/// One user's story bundle: author info + their ordered stories.
struct StoryBundle: Identifiable {
    var id: String { author.id }
    let author: UserChat
    let stories: [Story]
}

@Observable
final class UserStoryViewModel {
    /// The author whose bundle the viewer should open on. After that, the
    /// user can navigate to other bundles via swipe / auto-advance.
    let startingAuthorId: String

    // State
    private(set) var bundles: [StoryBundle] = []
    private(set) var currentUserIndex: Int = 0
    private(set) var currentStoryIndex: Int = 0
    private(set) var status: StoryScreenStatus = .common(.idle)

    /// Set to `true` once every bundle has been consumed. The view watches
    /// this to dismiss itself.
    private(set) var didReachEnd: Bool = false

    init(authorId: String = UserChat.mockUsers[0].id) {
        self.startingAuthorId = authorId
    }

    // MARK: - Loading

    func load() async {
        status = .common(.loading)

        // Swap with a real repository call
        // (`storyRepository.fetchStoryBundles()`) when the backend is
        // wired up. Mock lookup for now.
        let grouped = Story.mockStoriesByUser
        let orderedUserIds = orderedUserIdsWithStories()

        bundles = orderedUserIds.compactMap { userId in
            guard let author = UserChat.mockUser(forId: userId),
                  let stories = grouped[userId],
                  !stories.isEmpty else { return nil }
            return StoryBundle(author: author, stories: stories)
        }

        if bundles.isEmpty {
            status = .common(.failed("Không có story nào"))
            return
        }

        currentUserIndex = bundles.firstIndex { $0.author.id == startingAuthorId } ?? 0
        currentStoryIndex = 0
        status = .common(.loaded)
    }

    /// Users who have at least one story, in a stable display order. Mock
    /// data uses `[mockCurrentUser] + mockUsers` to keep "my story" first.
    private func orderedUserIdsWithStories() -> [String] {
        var ids: [String] = []
        if !Story.mockStories(for: UserChat.mockCurrentUser.id).isEmpty {
            ids.append(UserChat.mockCurrentUser.id)
        }
        for user in UserChat.mockUsers where !Story.mockStories(for: user.id).isEmpty {
            ids.append(user.id)
        }
        return ids
    }

    // MARK: - Derived accessors

    var currentBundle: StoryBundle? {
        bundles.indices.contains(currentUserIndex) ? bundles[currentUserIndex] : nil
    }

    var currentAuthor: UserChat? { currentBundle?.author }

    var storiesInCurrentBundle: [Story] { currentBundle?.stories ?? [] }

    var currentStory: Story? {
        guard let stories = currentBundle?.stories,
              stories.indices.contains(currentStoryIndex) else { return nil }
        return stories[currentStoryIndex]
    }

    // MARK: - Navigation

    /// True while any story remains after the current one (in this bundle or later bundles).
    var canGoNext: Bool {
        if currentStoryIndex + 1 < storiesInCurrentBundle.count { return true }
        return currentUserIndex + 1 < bundles.count
    }

    /// True while any story exists before the current one (in this bundle or earlier bundles).
    var canGoPrevious: Bool {
        if currentStoryIndex > 0 { return true }
        return currentUserIndex > 0
    }

    /// Advance one story. Rolls over to the next user's first story when the
    /// current bundle finishes. Sets `didReachEnd = true` at the very end.
    func next() {
        if currentStoryIndex + 1 < storiesInCurrentBundle.count {
            currentStoryIndex += 1
        } else if currentUserIndex + 1 < bundles.count {
            currentUserIndex += 1
            currentStoryIndex = 0
        } else {
            didReachEnd = true
        }
    }

    /// Rewind one story. Rolls back to the previous user's last story when
    /// at the start of a bundle. Does nothing at the very beginning.
    func previous() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        } else if currentUserIndex > 0 {
            currentUserIndex -= 1
            currentStoryIndex = max(0, storiesInCurrentBundle.count - 1)
        }
    }

    // MARK: - Cross-user swipes

    var canGoNextUser: Bool { currentUserIndex + 1 < bundles.count }
    var canGoPreviousUser: Bool { currentUserIndex > 0 }

    /// Jump to the next user's first story (swipe left). Dismisses on last user.
    func nextUser() {
        if currentUserIndex + 1 < bundles.count {
            currentUserIndex += 1
            currentStoryIndex = 0
        } else {
            didReachEnd = true
        }
    }

    /// Jump to the previous user's first story (swipe right).
    func previousUser() {
        guard currentUserIndex > 0 else { return }
        currentUserIndex -= 1
        currentStoryIndex = 0
    }

    /// Jump to an arbitrary user bundle (used by `TabView(.page)` binding).
    /// Resets story index to 0 to mirror Facebook's behavior.
    func jumpToUser(index: Int) {
        guard bundles.indices.contains(index), index != currentUserIndex else { return }
        currentUserIndex = index
        currentStoryIndex = 0
    }

    // MARK: - Playback control

    func play()     { status = .playing }
    func pause()    { status = .paused }
    func onBuffer() { status = .buffering }
    func onReady()  { status = .playing }
}
