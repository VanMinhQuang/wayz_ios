//
//  MapVinaDirectionsRepository.swift
//  wayz_ios
//

import CoreLocation

final class MapVinaDirectionsRepository: DirectionsRepositoryProtocol {
    private let remoteDataSource: MapVinaDirectionsRemoteDataSource

    init(remoteDataSource: MapVinaDirectionsRemoteDataSource = MapVinaDirectionsRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func route(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> NavigationRoute {
        let dto = try await remoteDataSource.fetchRoute(from: origin, to: destination)
        return NavigationRouteMapper.toEntity(dto)
    }
}
