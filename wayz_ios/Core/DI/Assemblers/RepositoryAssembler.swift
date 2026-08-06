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

        // MARK: - Places
        container.register(PlacesRemoteDataSource.self) { r in
            PlacesRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(PlacesLocalDataSource.self) { _ in
            PlacesLocalDataSource()
        }.inObjectScope(.container)

        container.register(PlacesRepositoryProtocol.self) { r in
            PlacesRepository(
                remoteDataSource: r.resolve(PlacesRemoteDataSource.self)!,
                localDataSource: r.resolve(PlacesLocalDataSource.self)!
            )
        }

        // MARK: - Reviews
        container.register(ReviewsRemoteDataSource.self) { r in
            ReviewsRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(ReviewsRepositoryProtocol.self) { r in
            ReviewsRepository(remoteDataSource: r.resolve(ReviewsRemoteDataSource.self)!)
        }

        // MARK: - Social (Follows)
        container.register(SocialRemoteDataSource.self) { r in
            SocialRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(SocialRepositoryProtocol.self) { r in
            SocialRepository(remoteDataSource: r.resolve(SocialRemoteDataSource.self)!)
        }

        // MARK: - Posts, Feed & Likes
        container.register(PostsRemoteDataSource.self) { r in
            PostsRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(PostsRepositoryProtocol.self) { r in
            PostsRepository(remoteDataSource: r.resolve(PostsRemoteDataSource.self)!)
        }

        // MARK: - Direct Messaging
        container.register(ConversationsRemoteDataSource.self) { r in
            ConversationsRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(ConversationsRepositoryProtocol.self) { r in
            ConversationsRepository(remoteDataSource: r.resolve(ConversationsRemoteDataSource.self)!)
        }

        container.register(RealtimeMessagingClient.self) { _ in
            RealtimeMessagingClient()
        }

        // MARK: - Upload Presigning
        container.register(UploadsRemoteDataSource.self) { r in
            UploadsRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(UploadsRepositoryProtocol.self) { r in
            UploadsRepository(remoteDataSource: r.resolve(UploadsRemoteDataSource.self)!)
        }

        // MARK: - Testing & Seeding
        container.register(SeedRemoteDataSource.self) { r in
            SeedRemoteDataSource(client: r.resolve(APIClient.self)!)
        }

        container.register(SeedRepositoryProtocol.self) { r in
            SeedRepository(remoteDataSource: r.resolve(SeedRemoteDataSource.self)!)
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
