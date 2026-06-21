//
//  RequestInterceptor.swift
//  wayz_ios
//

import Alamofire
import Foundation

/// Injects the Bearer token on every request and handles 401 token refresh.
final class AuthRequestInterceptor: RequestInterceptor {

    // MARK: - Adapt (inject token)
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        if let token = KeychainService.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // MARK: - Retry (handle 401 → token refresh)
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            request.retryCount == 0
        else {
            completion(.doNotRetry)
            return
        }

        Task {
            do {
                guard let refreshToken = KeychainService.shared.refreshToken else {
                    completion(.doNotRetry)
                    return
                }
                // Call refresh endpoint
                let dto: TokenDTO = try await APIClient.shared.request(.refreshToken(token: refreshToken))
                KeychainService.shared.accessToken = dto.accessToken
                KeychainService.shared.refreshToken = dto.refreshToken
                completion(.retry)
            } catch {
                KeychainService.shared.clearAll()
                completion(.doNotRetry)
            }
        }
    }
}
