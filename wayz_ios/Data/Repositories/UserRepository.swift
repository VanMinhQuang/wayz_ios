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

    func fetchUser(id: String) async throws -> User {
        // Return cached user if available
        if let cached = localDataSource.getUser(id: id) {
            return cached
        }
        // Otherwise fetch from remote and cache the result
        let dto    = try await remoteDataSource.fetchUser(id: id)
        let entity = UserMapper.toEntity(dto)
        localDataSource.saveUser(entity)
        return entity
    }

    func login(email: String, password: String) async throws -> AuthToken {
        let dto   = try await remoteDataSource.login(email: email, password: password)
        let token = TokenMapper.toEntity(dto)
        // Persist tokens to Keychain
        KeychainService.shared.accessToken  = token.accessToken
        KeychainService.shared.refreshToken = token.refreshToken
        return token
    }
}
