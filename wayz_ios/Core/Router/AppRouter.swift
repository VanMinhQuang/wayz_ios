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

    // MARK: - Init

    init() {
        isLoggedIn = KeychainService.shared.accessToken != nil
    }

    // MARK: - Navigation

    func push(_ route: AppRoute) {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
            path.append(route)
        }
    }

    func pop() {
        guard !path.isEmpty else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            path.removeLast()
        }
    }

    func popToRoot() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            path.removeLast(path.count)
        }
    }

    func replace(with route: AppRoute) {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
            path.removeLast(path.count)
            path.append(route)
        }
    }

    // MARK: - Auth state

    func logIn() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            isLoggedIn = true
            path.removeLast(path.count)
        }
    }

    func logOut() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isLoggedIn = false
            KeychainService.shared.clearAll()
        }
    }
}
