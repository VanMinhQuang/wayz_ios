//
//  AppEnvironment.swift
//  wayz_ios
//

enum AppEnvironment {
    case development
    case staging
    case production

    static var current: AppEnvironment {
        #if STAGING
        return .staging
        #elseif DEBUG
        return .development
        #else
        return .production
        #endif
    }

    var baseURL: String {
        switch self {
        case .development: return "https://dev-api.wayz.com/v1"
        case .staging:     return "https://staging-api.wayz.com/v1"
        case .production:  return "https://api.wayz.com/v1"
        }
    }
}
