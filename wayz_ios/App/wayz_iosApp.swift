//
//  wayz_iosApp.swift
//  wayz_ios
//

import SwiftUI
import FirebaseCore

@main
struct wayz_iosApp: App {
    private let router = AppRouter()
    private let session: AppSession

    init() {
        FirebaseApp.configure()
        _ = AppAssembler.shared
        // Resolve the singleton `AppSession` from DI so the SwiftUI environment
        // and any injected ViewModel share the exact same instance.
        session = DIContainer.shared.resolve(AppSession.self)
        if AppConfig.current.isLoggingEnabled {
            print(AppConfig.current)
        }
    }

    var body: some Scene {
        WindowGroup {
            AppNavigationStack(router: router)
                .environment(session)
        }
    }
}
