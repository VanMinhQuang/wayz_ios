//
//  SocialTabViewModel.swift
//  wayz_ios
//

import Foundation
import Observation
import SwiftUI

@Observable
final class SocialTabViewModel {
    // MARK: - State
    var moments: [Moment]

    init(moments: [Moment] = Moment.samples) {
        self.moments = moments
    }

    // MARK: - Intents

    func loadMoments() {
        moments = Moment.samples
    }

    func markSeen(_ moment: Moment) {
        guard let index = moments.firstIndex(where: { $0.id == moment.id }) else { return }
        moments[index].isSeen = true
    }
}

// MARK: - Per-page state

@Observable
final class MomentPageViewModel {
    // MARK: - State
    let moment: Moment
    var sentReaction: String? = nil
    var messageText: String = ""

    init(moment: Moment) {
        self.moment = moment
    }

    // MARK: - Intents

    func sendReaction(_ emoji: String) {
        // Explicitly animate the pop-in/pop-out. The photo view opts itself out of
        // this animation via `.transaction { $0.animation = nil }`, so only the
        // reaction bubble ever animates — the photo stays put.
        withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
            sentReaction = emoji
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                self?.sentReaction = nil
            }
        }
    }

    /// Sends whatever text is currently in `messageText` as a reaction, then clears the field.
    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        sendReaction(trimmed)
        messageText = ""
    }
}
