//
//  KeychainService.swift
//  wayz_ios
//

import Foundation
import Security

/// Simple Keychain wrapper for storing auth tokens.
/// Replace with a third-party library (e.g. KeychainAccess) if you need more features.
final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private enum Key {
        static let accessToken  = "wayz.access_token"
        static let refreshToken = "wayz.refresh_token"
    }

    var accessToken: String? {
        get { read(key: Key.accessToken) }
        set {
            if let value = newValue {
                save(key: Key.accessToken, value: value)
            } else {
                delete(key: Key.accessToken)
            }
        }
    }

    var refreshToken: String? {
        get { read(key: Key.refreshToken) }
        set {
            if let value = newValue {
                save(key: Key.refreshToken, value: value)
            } else {
                delete(key: Key.refreshToken)
            }
        }
    }

    func clearAll() {
        delete(key: Key.accessToken)
        delete(key: Key.refreshToken)
    }

    // MARK: - Private Keychain helpers

    private func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData:   data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func read(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrAccount:      key,
            kSecReturnData:       true,
            kSecMatchLimit:       kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
