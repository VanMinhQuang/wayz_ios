//
//  APIClient.swift
//  wayz_ios
//

import Alamofire
import Foundation

/// Shared Alamofire session wrapper.
/// All network calls go through this single entry point.
final class APIClient {
    static let shared = APIClient()

    private let session: Session

    private init(config: AppConfig = .current) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = config.apiTimeoutInterval
        configuration.timeoutIntervalForResource = config.apiTimeoutInterval * 2
        session = Session(
            configuration: configuration,
            interceptor: AuthRequestInterceptor()
        )
    }

    /// Perform a request and decode the response body into `T`.
    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        do {
            return try await session
                .request(router)
                .validate()
                .serializingDecodable(T.self)
                .value
        } catch let afError as AFError {
            throw mapError(afError)
        }
    }

    /// Perform a request and ignore the response body (e.g., DELETE).
    func requestVoid(_ router: APIRouter) async throws {
        do {
            _ = try await session
                .request(router)
                .validate()
                .serializingData()
                .value
        } catch let afError as AFError {
            throw mapError(afError)
        }
    }

    // MARK: - Private helpers

    private func mapError(_ error: AFError) -> NetworkError {
        if let statusCode = error.responseCode {
            switch statusCode {
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            default:  return .serverError(statusCode: statusCode)
            }
        }
        if let urlError = error.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .unknown(urlError)
            }
        }
        if let underlyingError = error.underlyingError as? DecodingError {
            return .decodingFailed(underlyingError)
        }
        return .unknown(error)
    }
}
