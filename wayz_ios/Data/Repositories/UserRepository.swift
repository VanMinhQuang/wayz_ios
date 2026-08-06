//
//  UserRepository.swift
//  wayz_ios
//

final class UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSource
    private let localDataSource: UserLocalDataSource

    init(remoteDataSource: UserRemoteDataSource, localDataSource: UserLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource  = localDataSource
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
