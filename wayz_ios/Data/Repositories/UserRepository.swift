//
//  UserRepository.swift
//  wayz_ios
//

import GoogleSignIn
import UIKit

final class UserRepository: UserRepositoryProtocol {

    private let remoteDataSource: UserRemoteDataSource
    private let localDataSource: UserLocalDataSource

    init(remoteDataSource: UserRemoteDataSource, localDataSource: UserLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource  = localDataSource
    }

    func loginWithGoogle() async throws -> AuthToken {
        let rootVC = try await MainActor.run { () throws -> UIViewController in
            guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let rootVC = scene.keyWindow?.rootViewController else {
                throw GoogleAuthError.noPresentingViewController
            }
            return rootVC
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)

        guard let idToken = result.user.idToken?.tokenString else {
            throw GoogleAuthError.missingIdToken
        }
        
        let username = result.user.profile?.name

        let dto = try await remoteDataSource.loginWithGoogle(idToken: idToken, userName: username )
        let token = TokenMapper.toEntity(dto)
        KeychainService.shared.accessToken  = token.accessToken
        KeychainService.shared.refreshToken = token.refreshToken
        return token
    }

    func register(email: String, username: String, password: String, fullName: String) async throws -> User {
        let dto = try await remoteDataSource.register(email: email, username: username, password: password, fullName: fullName)
        return UserMapper.toEntity(dto)
    }

    func login(email: String, password: String) async throws -> AuthToken {
        let dto   = try await remoteDataSource.login(email: email, password: password)
        let token = TokenMapper.toEntity(dto)
        // Persist tokens to Keychain
        KeychainService.shared.accessToken  = token.accessToken
        KeychainService.shared.refreshToken = token.refreshToken
        return token
    }

    func refreshToken() async throws -> AuthToken {
        guard let refreshToken = KeychainService.shared.refreshToken else {
            throw NetworkError.unauthorized
        }
        let dto   = try await remoteDataSource.refreshToken(refreshToken)
        let token = TokenMapper.toEntity(dto)
        KeychainService.shared.accessToken  = token.accessToken
        KeychainService.shared.refreshToken = token.refreshToken
        return token
    }

    func fetchUser(id: String) async throws -> User {
        // Return cached user if available
        if let cached = localDataSource.getUser(id: id) {
            return cached
        }
        let entity: User
        if id == "me" {
            entity = UserMapper.toEntity(try await remoteDataSource.getMe())
        } else {
            entity = UserMapper.toEntity(try await remoteDataSource.getPublicProfile(username: id))
        }
        localDataSource.saveUser(entity)
        return entity
    }

    func updateMe(fullName: String?, bio: String?, avatarURL: String?, isPrivate: Bool?) async throws -> User {
        var body: [String: Any] = [:]
        body["full_name"]  = fullName
        body["bio"]        = bio
        body["avatar_url"] = avatarURL
        body["is_private"] = isPrivate
        let dto = try await remoteDataSource.updateMe(body: body)
        let entity = UserMapper.toEntity(dto)
        localDataSource.saveUser(entity)
        return entity
    }
}

enum GoogleAuthError: LocalizedError {
    case noPresentingViewController
    case missingIdToken

    var errorDescription: String? {
        switch self {
        case .noPresentingViewController: return "Unable to find a view controller to present Google Sign-In."
        case .missingIdToken:             return "Google Sign-In succeeded but no ID token was returned."
        }
    }
}
