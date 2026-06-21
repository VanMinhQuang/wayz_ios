//
//  NetworkError.swift
//  wayz_ios
//

import Foundation

/// Typed networking errors surfaced to the Domain layer.
/// Never expose Alamofire types beyond the Data layer.
enum NetworkError: LocalizedError {
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingFailed(Error)
    case noInternetConnection
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .forbidden:
            return "You don't have permission to perform this action."
        case .notFound:
            return "The requested resource was not found."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .decodingFailed(let error):
            return "Failed to process server response: \(error.localizedDescription)"
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "The request timed out. Please try again."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
