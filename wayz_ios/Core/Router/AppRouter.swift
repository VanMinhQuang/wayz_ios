import SwiftUI
import Observation

@Observable
final class AppRouter {
    var path = NavigationPath()
    var presentedSheet: AppSheet?
    var presentedFullScreenCover: AppFullScreenCover?

    // MARK: - Stack navigation
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

    // MARK: - Modal presentation
    func present(_ sheet: AppSheet) {
        presentedSheet = sheet
    }

    func present(_ cover: AppFullScreenCover) {
        presentedFullScreenCover = cover
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
}
