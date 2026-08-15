//
//  AppSession.swift
//  wayz_ios
//
//  App-wide runtime state. Instantiated once in `wayz_iosApp`, injected
//  everywhere via `.environment(session)`. Read from any view with:
//
//      @Environment(AppSession.self) private var session
//
//  Add any other truly global runtime state here (feature flags,
//  unread counts, active call, etc.) — but keep it small; anything
//  scoped to a screen should live in its own ViewModel.
//

import Foundation
import Observation

@Observable
final class AppSession {
    /// The currently authenticated user, `nil` means signed out.
    var currentUser: User?

    /// Convenience — screens should gate on this instead of duplicating the
    /// nil-check on `currentUser`.
    var isSignedIn: Bool { currentUser != nil }

    // MARK: - Auth lifecycle

    func signIn(as user: User) {
        currentUser = user
    }

    func signOut() {
        currentUser = nil
    }
}
