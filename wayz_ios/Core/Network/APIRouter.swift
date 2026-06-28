//
//  APIRouter.swift
//  wayz_ios
//

import Alamofire
import Foundation

/// Centralized endpoint definitions.
/// Add a new `case` here for every API endpoint in the app.
enum APIRouter: URLRequestConvertible {

    // MARK: - Auth
    case login(email: String, password: String)
    case refreshToken(token: String)

    // MARK: - User
    case getUser(id: String)
    case updateUser(id: String, body: [String: Any])
    case deleteUser(id: String)

    // MARK: - Base URL
    private var baseURL: URL {
        // swiftlint:disable force_unwrapping
        AppConfig.current.apiBaseURL
        // swiftlint:enable force_unwrapping
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .login:                    return "/auth/login"
        case .refreshToken:             return "/auth/refresh"
        case .getUser(let id):          return "/users/\(id)"
        case .updateUser(let id, _):    return "/users/\(id)"
        case .deleteUser(let id):       return "/users/\(id)"
        }
    }

    // MARK: - HTTP Method
    private var method: HTTPMethod {
        switch self {
        case .login, .refreshToken:     return .post
        case .getUser:                  return .get
        case .updateUser:               return .put
        case .deleteUser:               return .delete
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .refreshToken(let token):
            return ["refresh_token": token]
        case .updateUser(_, let body):
            return body
        default:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30

        if let params = parameters {
            request = try JSONEncoding.default.encode(request, with: params)
        }
        return request
    }
}
