//
//  AppRoute.swift
//  wayz_ios
//

/// All navigable destinations in the app.
/// Add new cases here as you add new screens.
import Foundation

enum AppRoute: Hashable {
    case profile(userId: String)
    case settings
    case login
    case userChat(chatId: String)
    case userStory(userId: String)
}

enum AppSheet: Identifiable, Hashable {
    case login
    case editProfile(userId: String)

    var id: Self { self }
}

enum AppFullScreenCover: Identifiable, Hashable {
    case onboarding

    var id: Self { self }
}
