//
//  AppConfig.swift
//  wayz_ios
//

import Foundation

// MARK: - Environment

enum AppEnvironment: String, CustomStringConvertible {
    case development = "Development"
    case staging     = "Staging"
    case production  = "Production"

    static var current: AppEnvironment {
        #if STAGING
        return .staging
        #elseif DEBUG
        return .development
        #else
        return .production
        #endif
    }

    var description: String { rawValue }

    var isDevelopment: Bool { self == .development }
    var isProduction:  Bool { self == .production }
}

// MARK: - Config

struct AppConfig {

    // MARK: Singleton
    static let current = AppConfig(environment: .current)

    // MARK: Environment
    let environment: AppEnvironment

    // MARK: API
    var apiBaseURL: URL {
        switch environment {
        case .development: return URL(string: "https://dev-api.wayz.com/v1")!
        case .staging:     return URL(string: "https://staging-api.wayz.com/v1")!
        case .production:  return URL(string: "https://api.wayz.com/v1")!
        }
    }

    var apiTimeoutInterval: TimeInterval {
        switch environment {
        case .development: return 60
        case .staging:     return 30
        case .production:  return 30
        }
    }

    // MARK: App Version
    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }

    var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }

    var fullVersion: String { "\(appVersion) (\(buildNumber))" }

    // MARK: Feature Flags
    var isLoggingEnabled: Bool { !environment.isProduction }
    var isMockDataEnabled: Bool { environment.isDevelopment }
}

// MARK: - Debug Description

extension AppConfig: CustomStringConvertible {
    var description: String {
        """
        ┌─ AppConfig ─────────────────────────
        │ Environment : \(environment)
        │ API Base URL: \(apiBaseURL)
        │ App Version : \(fullVersion)
        │ Logging     : \(isLoggingEnabled)
        │ Mock Data   : \(isMockDataEnabled)
        └─────────────────────────────────────
        """
    }
}
