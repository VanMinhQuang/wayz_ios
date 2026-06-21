//
//  UserLocalDataSource.swift
//  wayz_ios
//

import Foundation

/// Local cache for user data.
/// Currently uses in-memory storage. Swap out for CoreData/SwiftData as needed.
final class UserLocalDataSource {
    private var cachedUser: User?

    func getUser(id: String) -> User? {
        guard cachedUser?.id == id else { return nil }
        return cachedUser
    }

    func saveUser(_ user: User) {
        cachedUser = user
    }

    func clearUser() {
        cachedUser = nil
    }
}
