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
        if let urlString = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
           let url = URL(string: urlString.replacingOccurrences(of: "\\", with: "")) {
            return url
        }
        switch environment {
        case .development: return URL(string: "https://dev-api.wayz.com/v1")!
        case .staging:     return URL(string: "https://staging-api.wayz.com/v1")!
        case .production:  return URL(string: "https://api.wayz.com/v1")!
        }
    }

    var apiTimeoutInterval: TimeInterval {
        if let timeoutString = Bundle.main.object(forInfoDictionaryKey: "APITimeout") as? String,
           let timeout = TimeInterval(timeoutString) {
            return timeout
        }
        if let timeoutInt = Bundle.main.object(forInfoDictionaryKey: "APITimeout") as? Int {
            return TimeInterval(timeoutInt)
        }
        switch environment {
        case .development: return 60
        case .staging:     return 30
        case .production:  return 30
        }
    }

    var socketURL: URL? {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SocketURL") as? String,
              let url = URL(string: urlString.replacingOccurrences(of: "\\", with: "")) else {
            return nil
        }
        return url
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
    var isLoggingEnabled: Bool {
        if let logLevel = Bundle.main.object(forInfoDictionaryKey: "LogLevel") as? String {
            return logLevel.lowercased() != "none"
        }
        return !environment.isProduction
    }

    var isMockDataEnabled: Bool {
        if let enableMock = Bundle.main.object(forInfoDictionaryKey: "EnableMockLocation") as? String {
            return enableMock.lowercased() == "yes" || enableMock.lowercased() == "true"
        }
        if let enableMock = Bundle.main.object(forInfoDictionaryKey: "EnableMockLocation") as? Bool {
            return enableMock
        }
        return environment.isDevelopment
    }

    // MARK: Map (MapLibre + MapVina)

    /// Injected at build time from `Config/Secrets.xcconfig` (gitignored) via
    /// `INFOPLIST_KEY_MapVinaAPIKey = $(MAPVINA_API_KEY)`. Never hardcode this value.

    /// MapVina API key injected from xcconfig (`MAPVINA_API_KEY`).
    var mapVinaAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "MapVinaAPIKey") as? String ?? ""
    }

    /// MapVina style URL injected from xcconfig
    var mapVinaStreetsStyleURL: URL {
        URL(string: "https://maps.mapvina.com/styles/v2/streets.json?key=\(mapVinaAPIKey)")!
    }
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
