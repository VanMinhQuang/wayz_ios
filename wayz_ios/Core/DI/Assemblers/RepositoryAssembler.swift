//
//  RepositoryAssembler.swift
//  wayz_ios
//

import Swinject

final class RepositoryAssembler: Assembly {
    func assemble(container: Container) {
        // MARK: - Data Sources
        container.register(UserRemoteDataSource.self) { r in
            UserRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(UserLocalDataSource.self) { _ in
            UserLocalDataSource()
        }.inObjectScope(.container)

        // MARK: - Repositories
        container.register(UserRepositoryProtocol.self) { r in
            UserRepository(
                remoteDataSource: r.resolve(UserRemoteDataSource.self)!,
                localDataSource: r.resolve(UserLocalDataSource.self)!
            )
        }
    }
}
