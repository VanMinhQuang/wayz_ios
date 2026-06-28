//
//  wayz_iosApp.swift
//  wayz_ios
//

import SwiftUI

@main
struct wayz_iosApp: App {
    private let router = AppRouter()

    init() {
        _ = AppAssembler.shared
        if AppConfig.current.isLoggingEnabled {
            print(AppConfig.current)
        }
    }

    var body: some Scene {
        WindowGroup {
            AppNavigationStack(router: router)
        }
    }
}
