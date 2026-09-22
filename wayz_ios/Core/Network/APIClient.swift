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
    private let decoder = JSONDecoder()

    private init(config: AppConfig = .current) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = config.apiTimeoutInterval
        configuration.timeoutIntervalForResource = config.apiTimeoutInterval * 2
        session = Session(
            configuration: configuration,
            interceptor: AuthRequestInterceptor()
        )
    }

    /// Perform a request, unwrap `ResponseWrapper<T>`, and return `data`.
    /// Throws `NetworkError.apiError` when `isSuccess == false`.
    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        // validate() is kept so the interceptor's retry() fires on 401.
        // serializingData() always populates `.data` even on validation failure,
        // letting us read the server's error body.
        let raw = await session
            .request(router)
            .validate()
            .serializingData()
            .response

        log(raw, router: router)

        
        guard let data = raw.data else {
            throw NetworkError.unknown(URLError(.zeroByteResource))
        }

        do {
            let wrapper = try decoder.decode(ResponseWrapper<T>.self, from: data)
            guard wrapper.isSuccess else {
                throw NetworkError.apiError(wrapper.message)
            }
            guard let value = wrapper.data else {
                throw NetworkError.unknown(URLError(.zeroByteResource))
            }
            return value
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    /// Perform a request and ignore `data`, but still check `isSuccess`.
    func requestVoid(_ router: APIRouter) async throws {
        let raw = await session
            .request(router)
            .validate()
            .serializingData()
            .response

        log(raw, router: router)

        if let afError = raw.error {
            throw mapError(afError, body: raw.data)
        }

        if let data = raw.data,
           let wrapper = try? decoder.decode(ResponseWrapper<AnyCodable>.self, from: data),
           !wrapper.isSuccess {
            throw NetworkError.apiError(wrapper.message)
        }
    }

    // MARK: - Error mapping

    private func mapError(_ afError: AFError, body: Data?) -> NetworkError {
        // HTTP-level errors (validation failure → non-2xx response)
        if let statusCode = afError.responseCode {
            let message = body.flatMap { extractMessage(from: $0) }
            switch statusCode {
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            default:  return .serverError(statusCode: statusCode, message: message)
            }
        }

        // Transport-level errors (no HTTP response received)
        let root = afError.underlyingError ?? afError

        if let urlError = root as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .unknown(urlError)
            }
        }

        // Serialization / decoding errors
        if case .responseSerializationFailed(let reason) = afError,
           case .decodingFailed(let decodingError) = reason {
            return .decodingFailed(decodingError)
        }

        return .unknown(afError)
    }

    // MARK: - Helpers

    /// Extracts a human-readable message from error response bodies.
    /// Handles both the standard `ResponseWrapper` format (`Message`) and
    /// common REST conventions (`message`, `error`, `detail`).
    private func extractMessage(from data: Data) -> String? {
        struct APIErrorBody: Decodable {
            let message: String?
            let error: String?
            let detail: String?
            let messageCapital: String?
            enum CodingKeys: String, CodingKey {
                case message, error, detail
                case messageCapital = "Message"
            }
        }
        guard let body = try? decoder.decode(APIErrorBody.self, from: data) else { return nil }
        return body.messageCapital ?? body.message ?? body.error ?? body.detail
    }

    // MARK: - Debug logging

    private func log(_ response: DataResponse<Data, AFError>, router: APIRouter) {
        #if DEBUG
        guard let urlRequest = try? router.asURLRequest() else { return }
        let method     = urlRequest.httpMethod ?? "?"
        let url        = urlRequest.url?.absoluteString ?? "?"
        let statusCode = response.response.map { String($0.statusCode) } ?? "no response"
        let body       = response.data.flatMap { String(data: $0.prefix(1000), encoding: .utf8) } ?? "-"
        let tag        = response.error == nil ? "✅" : "❌"
        print("\n[API] \(tag) \(method) \(url) → \(statusCode)\n\(body)\n")
        #endif
    }
}

// MARK: - Response Wrapper

/// Maps to the backend's universal `ResponseModel[T]`:
/// `{ "data": T | null, "isSuccess": bool, "Message": str }`
private struct ResponseWrapper<T: Decodable>: Decodable {
    let data: T?
    let isSuccess: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case data, isSuccess
        case message = "Message"
    }
}

/// Used for `requestVoid` to decode the wrapper without caring about `data`'s type.
private struct AnyCodable: Decodable {}
