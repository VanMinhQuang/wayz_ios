//
//  AppRoute.swift
//  wayz_ios
//

/// All navigable destinations in the app.
/// Add new cases here as you add new screens.
enum AppRoute: Hashable {
    case profile(userId: String)
    case settings
    case login
}
