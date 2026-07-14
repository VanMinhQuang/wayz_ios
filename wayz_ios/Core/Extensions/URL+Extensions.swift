//
//  URL+Extensions.swift
//  wayz_ios
//

import Foundation

extension URL {
    /// Returns a copy of the URL with the given query items appended,
    /// replacing any existing query.
    func withQuery(_ items: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = items.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
