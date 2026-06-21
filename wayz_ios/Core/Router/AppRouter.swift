//
//  AppRouter.swift
//  wayz_ios
//

import SwiftUI

/// Centralized NavigationStack path manager.
/// Inject via `.environment(router)` from the root view.
@Observable
final class AppRouter {
    var path = NavigationPath()
    var isLoggedIn: Bool = false

    // MARK: - Navigation

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func replace(with route: AppRoute) {
        path.removeLast(path.count)
        path.append(route)
    }

    // MARK: - Auth state

    func logIn() {
        isLoggedIn = true
        popToRoot()
    }

    func logOut() {
        isLoggedIn = false
        KeychainService.shared.clearAll()
    }
}
