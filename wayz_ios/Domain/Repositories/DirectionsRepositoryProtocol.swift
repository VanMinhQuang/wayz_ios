//
//  DirectionsRepositoryProtocol.swift
//  wayz_ios
//

import CoreLocation

enum DirectionsError: Error, LocalizedError {
    case invalidResponse
    case noRouteFound
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Couldn't read the directions response."
        case .noRouteFound: return "No route could be found between these points."
        case .network(let error): return error.localizedDescription
        }
    }
}

/// Abstract contract for fetching a turn-by-turn driving route between two
/// coordinates. The domain/presentation layers only depend on this — swap
/// the implementation (MapVina, OSRM, Google Directions, ...) without
/// touching ViewModels.
protocol DirectionsRepositoryProtocol {
    func route(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> NavigationRoute
}
