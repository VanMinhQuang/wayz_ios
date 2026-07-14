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

        // MARK: - Navigation / Directions
        container.register(MapVinaDirectionsRemoteDataSource.self) { _ in
            MapVinaDirectionsRemoteDataSource()
        }

        container.register(DirectionsRepositoryProtocol.self) { r in
            MapVinaDirectionsRepository(remoteDataSource: r.resolve(MapVinaDirectionsRemoteDataSource.self)!)
        }

        // Shared across the map + navigation screens so location permission is
        // only requested once and GPS updates keep flowing between the two.
        container.register(LocationManager.self) { _ in
            LocationManager()
        }.inObjectScope(.container)
    }
}
